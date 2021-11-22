terraform {
    backend "gcs" {
        bucket = "tf-bucket-275628"
        prefix = "terraform/state"
    }
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "3.55.0"
        }
    }
}

provider "google" {
    project     = var.project_id
    region      = var.region
    zone        = var.zone
}

module "instances" {
    source     = "./modules/instances"
}

module "storage" {
    source     = "./modules/storage"
}

module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 3.4.0"

    project_id   = var.project_id
    network_name = "tf-vpc-827361"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-central1"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-central1"
        }
    ]
}

resource "google_compute_firewall" "tf-firewall" {
    name    = "tf-firewall"
    network = "projects/qwiklabs-gcp-04-bf430394bd0a/global/networks/tf-vpc-827361"

    allow {
        protocol = "tcp"
        ports    = ["80"]
    }

    source_tags   = ["web"]
    source_ranges = ["0.0.0.0/0"]
}