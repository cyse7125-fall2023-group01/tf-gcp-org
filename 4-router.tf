resource "google_compute_router" "csye_7125_compute_router" {
  name    = "csye-7125-compute-router"
  region  = var.default_region
  network = google_compute_network.csye_7125_vpc_network.name
}