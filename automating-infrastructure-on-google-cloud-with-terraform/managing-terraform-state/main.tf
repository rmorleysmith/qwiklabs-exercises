terraform {
  backend "local" {
    path = "terraform/state/terraform.tfstate"
  }
}

provider "google" {
  project     = "qwiklabs-gcp-01-32934a9a8a12"
  region      = "us-central-1"
}

resource "google_storage_bucket" "test-bucket-for-state" {
  name        = "qwiklabs-gcp-01-32934a9a8a12"
  location    = "US"
  uniform_bucket_level_access = true
  force_destroy = true
}