terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      # version = "5.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "google" {
  # Configuration options
  credentials = file(var.service_account_credentials)
  project     = var.project_id
  region      = var.default_region
}

provider "google-beta" {
  credentials = file(var.service_account_credentials)
  project     = var.project_id
  region      = var.default_region
}