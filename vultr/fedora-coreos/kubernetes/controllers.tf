resource "vultr_server" "controllers" {
  count             = var.controller_count
  region_id         = data.vultr_region.cluster_region.id
  os_id             = data.vultr_os.os_image.id
  plan_id           = data.vultr_plan.controller_type.id
  label             = "${var.cluster_name}-controller-${count.index}"
  tag               = "${var.cluster_name}-controller"
  network_ids       = [vultr_network.cluster_network.id]
  firewall_group_id = vultr_firewall_group.cluster_firewall.id
  notify_activate   = var.notify_activate
  auto_backup       = var.autobackup_controllers
  user_data         = data.ct_config.controller-ignitions.*.rendered[count.index]
}

resource "vultr_dns_record" "controllers" {
  count  = var.controller_count
  domain = vultr_dns_domain.dns_zone.id
  name   = var.cluster_name
  data   = vultr_server.controllers[count.index].main_ip
  type   = "A"
  ttl    = 120
}

resource "vultr_dns_record" "etcds" {
  count  = var.controller_count
  domain = vultr_dns_domain.dns_zone.id
  name   = "${var.cluster_name}-etcd${count.index}"
  data   = vultr_server.controllers[count.index].main_ip
  type   = "A"
  ttl    = 120
}

data "ct_config" "controller-ignitions" {
  count    = var.controller_count
  content  = data.template_file.controller-configs.*.rendered[count.index]
  strict   = true
  snippets = var.controller_snippets
}

data "template_file" "controller-configs" {
  count = var.controller_count

  template = file("${path.module}/fcc/controller.yaml")

  vars = {
    # Cannot use cyclic dependencies on controllers or their DNS records
    etcd_name              = "etcd${count.index}"
    etcd_domain            = "${var.cluster_name}-etcd${count.index}.${var.dns_zone}"
    etcd_initial_cluster   = join(",", data.template_file.etcds.*.rendered)
    cluster_dns_service_ip = cidrhost(var.service_cidr, 10)
    cluster_domain_suffix  = var.cluster_domain_suffix
    ssh_keys               = yamlencode(var.ssh_keys)
    node_private_ip        = cidrhost(var.node_cidr, 2+count.index) 
    node_cidr_netmask      = split("/", var.node_cidr)[1]
    node_hostname          = "${var.cluster_name}-controller-${count.index}"
  }
}

data "template_file" "etcds" {
  count    = var.controller_count
  template = "etcd$${index}=https://$${cluster_name}-etcd$${index}.$${dns_zone}:2380"

  vars = {
    index        = count.index
    cluster_name = var.cluster_name
    dns_zone     = var.dns_zone
  }
}
