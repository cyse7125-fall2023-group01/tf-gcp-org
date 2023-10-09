resource "google_compute_instance" "csye7125_dns_compute_instance" {
  name         = "csye7125-dns-compute-instance"
  machine_type = "n1-standard-1"
  zone = "us-east1-b"

  allow_stopping_for_update = true
  hostname = "dev.gcp.sriharshaperi.me"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.csye_7125_vpc_network.self_link
    subnetwork = google_compute_subnetwork.public_subnets[0].self_link
    access_config {
      // Ephemeral public IP
      nat_ip = google_compute_address.csye_7125_nat_compute_address.address
    }
  }

  service_account {

    /* 
    
    Google recommends custom service accounts 
    to have cloud-platform scope and permissions granted via IAM Roles. 
    
    */
    email  = "csye-7125-sa@root-mapper-401202.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}