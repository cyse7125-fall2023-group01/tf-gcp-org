
provider "google" {
 project = var.project
 credentials = file(var.filename)
}
# resource "google_folder" "folder"{
#     display_name = "CSYE-7125-project"
#     parent = "organisation/csye7125-401203"
    

# }


resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  project = var.project
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
  project = var.project
}


resource "google_compute_network" "main" {
  name                            = "main"
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = false
  project = var.project
  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}

resource "google_compute_subnetwork" "private" {
  name                     = "private-subnet"
  ip_cidr_range            = var.subnet_private_ip_cidr
  region                   = "us-east1"
  project = var.project
  network                  = google_compute_network.main.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }
  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.52.0.0/20"
  }
}
resource "google_compute_subnetwork" "public" {
  name                     = "public"
  ip_cidr_range            = "172.17.1.0/28"
  region                   = "us-east1"
  project = var.project
  network                  = google_compute_network.main.id
  

 
}

resource "google_compute_router" "router" {
  name    = "router"
  region  = "us-east1"
  project = var.project
  network = google_compute_network.main.id
}


resource "google_compute_router_nat" "nat" {
  name   = "nat"
  router = google_compute_router.router.name
  project = var.project
  region = "us-east1"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.nat.self_link]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "nat" {
  name         = "nat"
  region ="us-east1"
  address_type = "EXTERNAL"
  project = var.project

  network_tier = "PREMIUM"

  depends_on = [google_project_service.compute]
}
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  project = var.project
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22","80","443"]
  }

  source_ranges = ["0.0.0.0/0"]
}
resource "google_container_cluster" "primary" {
  name                     = "primary"
  location                 = "us-east1"
  project = var.project
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.main.self_link
  subnetwork               = google_compute_subnetwork.private.self_link
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  networking_mode          = "VPC_NATIVE"
  deletion_protection = false

  # Optional, if you want multi-zonal cluster
 
 node_config{
    disk_type = "pd-standard"
 }

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "csye7125-401203.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
binary_authorization{
    evaluation_mode ="PROJECT_SINGLETON_POLICY_ENFORCE"
}

master_authorized_networks_config {
      cidr_blocks {
        cidr_block   = "${google_compute_instance.bastion.network_interface.0.network_ip}/32"
        display_name = "public-subnet-access-to-gke"
      }
    }
 
}
resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
  project = var.project
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool
resource "google_container_node_pool" "general" {
  name       = "general"
  cluster    = google_container_cluster.primary.id
  project = var.project
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    image_type = "COS_CONTAINERD"
    machine_type = "e2-small"
    disk_type = "pd-standard" 

    labels = {
      role = "general"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_container_node_pool" "spot" {
  name    = "spot"
  cluster = google_container_cluster.primary.id
  project = var.project

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 0
    max_node_count = 7
  }

  node_config {
    preemptible  = true
    machine_type = "e2-small"

    labels = {
      team = "devops"
    }

    taint {
      key    = "instance_type"
      value  = "spot"
      effect = "NO_SCHEDULE"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_compute_instance" "bastion" {
  name         = "bastion-instance"
  machine_type = "e2-small"
  project      = var.project
  zone = "us-east1-b"
  

  network_interface {
    subnetwork = google_compute_subnetwork.public.self_link
    access_config {

    }
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }
  metadata_startup_script = <<-EOF
  !#/bin/bash
  sudo apt-get install kubectl -y
  sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin -y
  curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
  sudo apt-get install apt-transport-https --yes
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
  sudo apt-get update
  sudo apt-get install helm
  EOF
}