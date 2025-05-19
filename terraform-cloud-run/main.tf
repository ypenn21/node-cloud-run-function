data "google_project" "project" {}

resource "google_artifact_registry_repository" "default" {
  location      = "us-central1"
  repository_id = var.repo
  format        = "DOCKER"
}

# Define the container image name
locals {
  image_name = "us-central1-docker.pkg.dev/${data.google_project.project.project_id}/${var.repo}/${var.image_tag}"
}

# Cloud Run service that replaces Cloud Functions
resource "google_cloud_run_v2_service" "default" {
  name        = "cloud-run-function"
  location    = "us-central1"
  description = "a new function"
  deletion_protection = false
  template {
    containers {
      name = "cloud-run-function"
      image = local.image_name
      base_image_uri = var.base_image
    }
  }
  build_config{
    function_target = "helloHttp"
    image_uri = local.image_name
    base_image = var.base_image
    enable_automatic_updates = true
  }
  lifecycle {
    ignore_changes = [
      template[0].containers[0].image
    ]
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
