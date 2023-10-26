locals {
  bastion_name = format("%s-bastion", var.cluster_name)
  bastion_zone = data.google_compute_zones.available.names[0]
}

module "bastion" {
  source  = "terraform-google-modules/bastion-host/google"
  version = "~> 5.0"

  network        = google_compute_network.csye_7125_vpc_network.self_link
  subnet         = google_compute_subnetwork.public_subnets[0].self_link
  project        = var.project_id
  host_project   = var.project_id
  name           = local.bastion_name
  zone           = local.bastion_zone
  image_project  = "debian-cloud"
  machine_type   = var.machine_type
  startup_script = templatefile("${path.module}/templates/startup-script.tftpl", {
      CLUSTER_NAME = var.cluster_name
      COMPUTE_ZONE = local.bastion_zone
  })
  members        = ["serviceAccount:${var.service_account_email}"]
  shielded_vm    = "false"
}