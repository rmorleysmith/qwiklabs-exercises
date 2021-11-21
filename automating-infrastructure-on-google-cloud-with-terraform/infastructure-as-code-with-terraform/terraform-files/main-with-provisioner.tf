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

# Create VM instance
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  tags         = ["web", "dev"]
  provisioner "local-exec" {
    command = "echo ${google_compute_instance.vm_instance.name}:  ${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip} >> ip_address.txt"
  }
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
