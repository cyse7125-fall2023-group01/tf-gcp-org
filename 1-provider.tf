terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.0.0"
    }
  }
}

provider "google" {
  # Configuration options
  credentials = file(var.service_account_credentials)
  project     = var.project_id
  region      = var.default_region
}