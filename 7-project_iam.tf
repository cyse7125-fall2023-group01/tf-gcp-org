# resource "google_project_iam_custom_role" "csye_7125_network_access_permissions" {
#   role_id     = "csye7125NetworkAccessCustomPermissions"
#   title       = "csye-7125-Network-Access-Custom-Permissions"
#   description = "csye-7125-Network-Access-Custom-Permissions"
  
#   permissions = [
#     "iam.roleAdmin",
#     "iam.serviceAccountTokenCreator",
#     "iam.serviceAccountUser",
#     "serviceusage.serviceUsageAdmin",
#     "iam.serviceAccountAdmin",
#     "serviceusage.serviceUsageAdmin",
#     "compute.viewer",
#     "compute.networks.access",
#     "compute.networks.create",
#     "compute.networks.delete",
#     "compute.networks.get",
#     "compute.networks.list",
#     "compute.networks.update",
#     "compute.networks.use"
#     "compute.networks.create"
#   ]
# }

# resource "google_project_iam_member" "iam_member" {
#   project = var.project_id
#   role    = google_project_iam_custom_role.csye_7125_network_access_permissions.id
#   member  = "ServiceAccount:csye-7125-sa@root-mapper-401202.iam.gserviceaccount.com"
# }

resource "google_project_service" "compute_service" {
  project                    = var.project_id
  service                    = "iam.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}