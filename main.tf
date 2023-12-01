provider "google" {
 project = "root-mapper-401202"
 credentials = file("gcp_sa_key.json")
}
data "google_client_config" "provider"{}

module "gke_cluster"{
    source = "./gke_cluster"
    project = "root-mapper-401202"
    region = "us-east1"
    subnet_private_ip_cidr = "10.0.0.0/18"
    subnet_public_ip_cidr = "172.17.1.0/28"
    ip_cidr_range_private = "10.48.0.0/14"
# For the `google_compute_instance` resource
    bastion_machine_type = "e2-small"
    bastion_zone = "us-east1-b"

}
data "google_container_cluster" "primary"{
    name = "primary"
    location = "us-east1"
    depends_on = [module.gke_cluster]
}
# provider "kubernetes" {
#         version = "~>1.12.0"
#         load_config_file = "false"
#         host = "https://${data.google_container_cluster.primary.endpoint}"
#         token = data.google_client_config.provider.access_token
#         cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
# }
# provider "helm" {
#     version ="~> 1.2.4"
#     kubernetes{
#         load_config_file ="false"
#         host = "https://${data.google_container_cluster.primary.endpoint}"
#         token = data.google_client_config.provider.access_token
#         cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
#     }


# }
# resource "helm_release" "example" {
#   name  = "redis"
#   chart = "https://charts.bitnami.com/bitnami/redis-10.7.16.tgz"
#   depends_on = [data.google_container_cluster.primary]
#   namespace = "default"
# }