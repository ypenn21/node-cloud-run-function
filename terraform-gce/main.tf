module "project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 18.0"
  project_id = var.project_id
  disable_services_on_destroy = false
  disable_dependent_services  = false

  activate_apis = [
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "logging.googleapis.com",
    "storage-component.googleapis.com",
    "artifactregistry.googleapis.com",
    "vpcaccess.googleapis.com",
    "servicenetworking.googleapis.com"
  ]
}

resource "google_compute_network" "auto_vpc" {
  name = "default-vpc"
  depends_on = [module.project_services]
  auto_create_subnetworks = true # This creates subnets in each region, similar to a default VPC
}

resource "google_compute_instance" "alloydb_client" {
  name         = "alloydb-client"
  zone         = var.zone
  machine_type = "e2-medium"
  depends_on = [google_compute_network.auto_vpc]
  boot_disk {
    initialize_params {
      // The latest Debian 12 image (excluding arm64)
      image = "debian-12"
    }
  }

  shielded_instance_config {
    enable_secure_boot = true
  }
  // Network interface with external access
  network_interface {
    network = google_compute_network.auto_vpc.name
  }
    metadata_startup_script = <<EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt-get install --yes postgresql-client
  # Check extension is installed with \dx
  EOF
  
  tags = ["all-access"]

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
