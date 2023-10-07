resource "google_service_account" "csye_7125_sa" {
  account_id   = "csye-7125-sa"
  display_name = "Service Account"
}

# resource "google_service_account_iam_binding" "admin-account-iam" {
#   service_account_id = google_service_account.csye_7125_sa.name
#   role               = "roles/iam.serviceAccountAdmin"

#   members = [
#     "ServiceAccount:${google_service_account.csye_7125_sa.email}",
#   ]
# }

# resource "google_project_iam_member" "project" {
#   project = var.project_id
#   role    = "roles/editor"
#   member  = "ServiceAccount:${google_service_account.csye_7125_sa.email}"
# }