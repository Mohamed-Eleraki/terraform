terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.28.0"
    }
  }
}

provider "google" {
  project     = "main-aspect-456107-g4"
  region      = "us-central1-a"
  credentials = "/home/eraki/.gcp/secrets/eraki-terraform-srv-key.json"
}