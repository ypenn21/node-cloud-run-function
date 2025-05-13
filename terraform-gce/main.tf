
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

resource "google_compute_network" "my_vpc" {
  project = "<your project here>"
  name = "my-vpc"
  depends_on = [module.project_services]
  auto_create_subnetworks = false # This creates subnets in each region, similar to a default VPC
}

resource "google_compute_subnetwork" "my_subnet" {
  project       = "<your project here>"
  name          = "my-subnet"
  ip_cidr_range = "192.168.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.my_vpc.id
}

resource "google_compute_instance" "my_www_vm_1" {
  project      = "my-project"
  name         = "my-www-vm-1"
  machine_type = "e2-micro"
  zone         = "us-central1-b"
  tags = ["www"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.my_vpc.id
    subnetwork = google_compute_subnetwork.my_subnet.id
    access_config {}
  }

  metadata_startup_script = "apt update && apt install -y nginx"

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  # allow_stopping_for_update = true
}

# resource "google_compute_project_metadata" "default" {
#  metadata = {
#    enable-oslogin = "TRUE"
#  }

resource "google_compute_firewall" "allow_www" {
  name          = "allow-www"
  project       = "qwiklabs-gcp-01-611bc819173a"
  network       = google_compute_network.my_vpc.id
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["www"]
  allow {
    protocol = "tcp"
    ports    = ["80"]
  } 
}

resource "google_compute_firewall" "allow_iap" {
  name          = "allow-iap"
  project       = "qwiklabs-gcp-01-611bc819173a"
  network       = google_compute_network.my_vpc.id
  source_ranges = ["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
