resource "vultr_network" "cluster_network" {
  description = "${var.cluster_name} private network"
  region_id   = data.vultr_region.cluster_region.id
}

resource "vultr_firewall_group" "cluster_firewall" {
  description = "${var.cluster_name} cluster firewall"
}

resource "vultr_dns_domain" "dns_zone" {
  domain = var.dns_zone
}
