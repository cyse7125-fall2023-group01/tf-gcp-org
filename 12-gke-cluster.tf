module "gke" {
  source                  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id              = var.project_id
  name                    = var.cluster_name
  region                  = var.default_region
  zones                   = data.google_compute_zones.available.names //multi-zone
  network                 = google_compute_network.csye_7125_vpc_network.name
  subnetwork              = google_compute_subnetwork.private_subnets[0].name
  ip_range_pods           = "private-k8s-pod-range"
  ip_range_services       = "private-k8s-service-range"

  enable_private_endpoint = false   //private cluster
  enable_private_nodes = true
  default_max_pods_per_node = 2

  master_authorized_networks = [{
    cidr_block   = "${module.bastion.ip_address}/32"
    display_name = "Bastion Host"
  }]
  grant_registry_access = true
  node_pools = [
    {
      name          = "webapp-private-cluster-node-pool"
      machine_type              = "e2-standard-2"
      node_locations = join(",", data.google_compute_zones.available.names)
      min_count     = 1
      max_count     = 1
      auto_upgrade  = true
      node_metadata = "GKE_METADATA"
      private       = true      //private node pool

      local_ssd_count           = 0
      spot                      = false
      disk_size_gb              = 50
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      enable_gcfs               = false
      enable_gvnic              = false

      logging_variant           = "DEFAULT"
      auto_repair               = true
      auto_upgrade              = true

      service_account           = var.service_account_email
      preemptible               = false
    #   initial_node_count        = 3

      deletion_protection     = false
      enable_binary_authorization = true
    }
  ]
}