terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.34.0"
    }
  }
}

resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name                        = "${random_id.default.hex}-gcf-source" # Every bucket name must be globally unique
  location                    = "US"
  uniform_bucket_level_access = true
}

data "archive_file" "default" {
  type        = "zip"
  output_path = "/tmp/function-source.zip"
  source_dir  = "functions/hello-world/"
}

resource "google_storage_bucket_object" "object" {
  name   = "function-source.zip"
  bucket = google_storage_bucket.default.name
  source = data.archive_file.default.output_path # Add path to the zipped function source code
}

data "google_project" "project" {}

# Create a Cloud Build for the function (no trigger - for artifact registry)
resource "google_artifact_registry_repository" "default" {
  location      = "us-central1"
  repository_id = "function-repo"
  format        = "DOCKER"
}

# Define the container image name
locals {
  image_name = "us-central1-docker.pkg.dev/${data.google_project.project.project_id}/function-repo/function-image:latest"
}

# Cloud Run service that replaces Cloud Functions
resource "google_cloud_run_v2_service" "default" {
  name        = "cloud-run-function"
  location    = "us-central1"
  description = "a new function"
  template {
    containers {
      name = "cloud-run-function"
      image = "us-central1-docker.pkg.dev/genai-playground24/app-genai/cloud-run-function-v2:v1" # Container image built from your function in the previous step.
      base_image_uri = "us-central1-docker.pkg.dev/serverless-runtimes/google-22/runtimes/nodejs22"
    }
  }
  build_config{
    function_target = "helloHttp"
    image_uri = "us-central1-docker.pkg.dev/genai-playground24/app-genai/cloud-run-function-v2:v1"
    base_image = "us-central1-docker.pkg.dev/serverless-runtimes/google-22/runtimes/nodejs22"
    enable_automatic_updates = true
  }
}

# IAM permissions to allow public invocation
resource "google_cloud_run_v2_service_iam_member" "noauth" {
  location = google_cloud_run_v2_service.default.location
  name     = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "service_uri" {
  value = google_cloud_run_v2_service.default.uri
}
