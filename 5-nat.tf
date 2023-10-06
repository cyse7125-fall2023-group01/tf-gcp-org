resource "google_compute_router_nat" "csye_7125_nat" {
  name                               = "csye-7125-nat"
  router                             = google_compute_router.csye_7125_compute_router.name
  region                             = google_compute_router.csye_7125_compute_router.region
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }

  nat_ips = [google_compute_address.csye_7125_nat_compute_address.self_link]
}

resource "google_compute_router_nat" "csye_7125_subnet_nat" {

  count = length(google_compute_subnetwork.private_subnets)
  name  = "csye-7125-subnet-nat-${count.index}"

  router                             = google_compute_router.csye_7125_compute_router.name
  region                             = google_compute_router.csye_7125_compute_router.region
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.private_subnets[count.index].name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }

  nat_ips = [google_compute_address.csye_7125_nat_compute_address.self_link]
}

resource "google_compute_address" "csye_7125_nat_compute_address" {
  name         = "csye-7125-nat-compute-address"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
  depends_on   = [google_project_service.compute_service]
}