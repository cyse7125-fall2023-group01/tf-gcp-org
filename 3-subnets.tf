data "google_compute_zones" "available" {
}

resource "google_compute_subnetwork" "private_subnets" {
  count                    = length(data.google_compute_zones.available.names)
  name                     = "test-subnetwork"
  ip_cidr_range            = "10.0.${count.index + 16}.0/18"
  region                   = var.default_region
  network                  = google_compute_network.csye_7125_vpc_network.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.21.${count.index + 24}.0/14"
  }

  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.32.${count.index + 48}.0/20"
  }
}