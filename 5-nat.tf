resource "google_compute_router_nat" "csye_7125_nat" {
  name                               = "csye-7125-nat"
  router                             = google_compute_router.csye_7125_compute_router.name
  region                             = google_compute_router.csye_7125_compute_router.region
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_address" "csye_7125_nat_compute_address" {
  name         = "csye-7125-nat-compute-address"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}
