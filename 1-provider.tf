provider "google" {
  # credentials = var.service_account_credentials
  credentials = file("/Users/sriha/Desktop/advcloud/gcp-account/service-account-creds/csye-7125-sa/gcp_sa_key.json")
  project     = var.project_id
  region      = var.default_region
}