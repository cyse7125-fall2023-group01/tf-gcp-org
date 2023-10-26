data "google_compute_zones" "available" {

}

resource "google_compute_subnetwork" "private_subnets" {
  count                    = length(data.google_compute_zones.available.names)
  name                     = "private-subnet-${count.index}"
  ip_cidr_range            = "10.21.${count.index + 16}.0/24"
  region                   = var.default_region
  network                  = google_compute_network.csye_7125_vpc_network.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "private-k8s-pod-range"
    ip_cidr_range = "10.22.${count.index + 16}.0/24"
  }

  secondary_ip_range {
    range_name    = "private-k8s-service-range"
    ip_cidr_range = "10.23.${count.index + 16}.0/24"
  }
}


resource "google_compute_subnetwork" "public_subnets" {
  count                    = length(data.google_compute_zones.available.names)
  name                     = "public-subnet-${count.index}"
  ip_cidr_range            = "10.1.${count.index + 16}.0/24"
  region                   = var.default_region
  network                  = google_compute_network.csye_7125_vpc_network.id
  private_ip_google_access = false

  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.2.${count.index + 16}.0/24"
  }

  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.3.${count.index + 16}.0/24"
  }
}