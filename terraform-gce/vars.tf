variable "project_id" {
  type        = string
  description = "The GCP project ID."
}

variable "project_number" {
  type        = string
  description = "The GCP project ID."
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "The GCP region where resources will be created."
}

variable "zone" {
  type        = string
  default     = "us-central1-a"
  description = "The GCP zone where resources will be created."
}
