variable "default_region" {
  description = "gcp organization project default region"
}

variable "project_id" {
  description = "gcp organization project id"
}

variable "service_account_credentials" {
  description = "gcp service account credentials"
}

variable "machine_type" {
  description = "type of compute instance"
}

variable "gcp_dev_hosted_zone" {
  description = "gcp dev hosted zone domain name"
}

variable "machine_image" {
  description = "type of machine image used for compute instance"
}

variable "service_account_email" {
  description = "service account email"
}

variable "compute_instance_availability_zone" {
  description = "availability zone in the configured region for compute instance"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = "webapp-private-cluster"
}

# variable "bastion_members" {
#   type        = list(string)
#   description = "List of users, groups, SAs who need access to the bastion host"
# }