resource "google_dns_record_set" "frontend" {
  name = "dev.gcp.sriharshaperi.me."
  type = "A"
  ttl  = 60
  managed_zone = "dev-subdomain-csye-gcp"
  rrdatas = [google_compute_address.csye_7125_nat_compute_address.address]
}