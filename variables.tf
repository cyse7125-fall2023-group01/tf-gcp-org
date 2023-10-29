variable "project" {
  description = "The Google Cloud project ID."
  type        = string
}

variable "filename" {
  description = "Path to the Google Cloud service account key JSON file."
  type        = string
  default     = "gcp_sa_key.json"
}

variable "region" {
  description = "The Google Cloud region for resources."
  type        = string
}

variable "subnet_public_ip_cidr" {
  description = "IP CIDR range for the private subnetwork."
  type        = string
}

variable "subnet_private_ip_cidr" {
  description = "IP CIDR range for the private subnetwork."
  type        = string
}

variable "ip_cidr_range_private" {
  description = "IP CIDR range for the public subnetwork."
  type        = string
}

variable "bastion_machine_type" {
  description = "Machine type for the bastion instance."
  type        = string
}

variable "bastion_zone" {
  description = "Zone for the bastion instance."
  type        = string
}


