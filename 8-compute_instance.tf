resource "google_compute_instance" "csye7125_dns_compute_instance" {
  name         = "csye7125-dns-compute-instance"
  machine_type = var.machine_type
  zone         = data.google_compute_zones.available.names[0]

  allow_stopping_for_update = true
  hostname                  = var.gcp_dev_hosted_zone

  boot_disk {
    initialize_params {
      image = var.machine_image
    }
  }

  network_interface {
    network    = google_compute_network.csye_7125_vpc_network.self_link
    subnetwork = google_compute_subnetwork.public_subnets[0].self_link
    access_config {
      nat_ip = google_compute_address.csye_7125_nat_compute_address.address
    }
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }
}