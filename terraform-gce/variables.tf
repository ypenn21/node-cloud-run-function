# Define variables to be used 
# These are instantiated in the terraform.tfvars file

variable "project_id" {
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

variable "vm_prefix" {
  type        = string
  description = "the common VM names prefix"
  default     = "vm"
}