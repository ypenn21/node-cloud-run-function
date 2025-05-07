variable "base_image" {
  type        = string
  description = "The full URL of the base image with the run time to deploy to Cloud Run (e.g., REGION-docker.pkg.dev/PROJECT_ID/REPO_ID/IMAGE_NAME:TAG)."
  default = "us-central1-docker.pkg.dev/serverless-runtimes/google-22/runtimes/nodejs22"  
}
variable "image_tag" {
  type        = string
  description = "The full URL of the base image with the run time to deploy to Cloud Run (e.g., REGION-docker.pkg.dev/PROJECT_ID/REPO_ID/IMAGE_NAME:TAG)."
  default = "cloud-run-function-v2:v1"
}
variable "repo" {
  type        = string
  description = "artifact registry"
  default = "cloud-run-functions"
}
