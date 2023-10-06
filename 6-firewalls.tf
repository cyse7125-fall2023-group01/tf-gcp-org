resource "google_compute_firewall" "csye_7125_firewall" {
  name    = "csye-7125-firewall"
  network = google_compute_network.csye_7125_vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}