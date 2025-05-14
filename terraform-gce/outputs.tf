# This file defines the output variables for the Terraform configuration.
# outputs.tf 

output "vm_1_name" {
  description = "The www VM 1 name."
  value       = google_compute_instance.my_www_vm_1.name
}

output "web-server-url" {
 value = join("",["http://",google_compute_instance.my_www_vm_1.network_interface.0.access_config.0.nat_ip,":80"])
}