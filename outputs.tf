output "cluster_name" {
  description = "Cluster name"
  value       = module.gke.name
}

output "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.gke.location
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.gke.endpoint
}

output "master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = module.gke.master_authorized_networks_config
}

output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.gke.ca_certificate
}

output "bastion_name" {
  description = "Name of the bastion host"
  value       = module.bastion.hostname
}