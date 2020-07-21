resource "vultr_network" "cluster_network" {
  description = "${var.cluster_name} private network"
  region_id   = data.vultr_region.cluster_region.id
}

resource "vultr_dns_domain" "dns_zone" {
  domain = var.dns_zone
}

resource "vultr_firewall_group" "cluster_firewall" {
  description = "${var.cluster_name} cluster firewall"
}

resource "vultr_firewall_rule" "ssh" {
  firewall_group_id = vultr_firewall_group.cluster_firewall.id
  protocol = "tcp"
  network = "0.0.0.0/0"
  from_port = "22"
}

resource "vultr_firewall_rule" "icmp" {
  firewall_group_id = vultr_firewall_group.cluster_firewall.id
  protocol = "icmp"
  network = "0.0.0.0/0"
}

resource "vultr_firewall_rule" "kube_api_server" {
  firewall_group_id = vultr_firewall_group.cluster_firewall.id
  protocol = "tcp"
  network = "0.0.0.0/0"
  from_port = "6443"
}  


  
