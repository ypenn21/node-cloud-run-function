# This file defines the output variables for the Terraform configuration.
# outputs.tf 

output "vm_1_name" {
  description = "The www VM 1 name."
  value       = google_compute_instance.my_www_vm_1.name
}