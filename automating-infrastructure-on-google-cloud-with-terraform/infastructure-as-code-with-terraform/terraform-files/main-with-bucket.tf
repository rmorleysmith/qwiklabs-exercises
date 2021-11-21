terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

# Specify provider
provider "google" {
  version = "3.5.0"
  project = "qwiklabs-gcp-02-fce74eb6bfa6"
  region  = "us-central1"
  zone    = "us-central1-c"
}

# Create VPC network
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

# Create static IP
resource "google_compute_address" "vm_static_ip" {
  name = "terraform-static-ip"
}

# Create basic VM instance which uses static IP
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  tags         = ["web", "dev"]
  # ...
  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
        nat_ip = google_compute_address.vm_static_ip.address
    }
  }
}

# Create a new instance that uses a bucket
resource "google_compute_instance" "another_instance" {
  # Tells Terraform that this VM instance must be created only after the
  # storage bucket has been created.
  depends_on = [google_storage_bucket.example_bucket]
  name         = "terraform-instance-2"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
}

# New resource for the storage bucket our application will use.
resource "google_storage_bucket" "example_bucket" {
  name     = "itsjustrizzy-21-11-2021"
  location = "US"
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}
