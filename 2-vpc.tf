resource "google_compute_network" "csye_7125_vpc_network" {
  project                         = var.project_id
  routing_mode                    = "REGIONAL"
  name                            = "csye-7125-vpc-network"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = true
  
  depends_on = [
    google_project_service.iam_service,
    google_project_service.compute_service
  ]
}