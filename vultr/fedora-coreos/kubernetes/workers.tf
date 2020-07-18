resource "vultr_server" "workers" {
  count             = var.worker_count
  region_id         = data.vultr_region.cluster_region.id
  os_id             = data.vultr_os.os_image.id
  plan_id           = data.vultr_plan.worker_type.id
  label             = "${var.cluster_name}-worker-${count.index}"
  hostname          = "${var.cluster_name}-worker-${count.index}"
  tag               = "${var.cluster_name}-worker"
  network_ids       = [vultr_network.cluster_network.id]
  firewall_group_id = vultr_firewall_group.cluster_firewall.id
  notify_activate   = var.notify_activate
  user_data         = data.ct_config.worker-ignitions.*.rendered[count.index]
}

data "ct_config" "worker-ignitions" {
  count    = var.worker_count
  content  = data.template_file.worker-config.*.rendered[count.index]
  strict   = true
  snippets = var.worker_snippets
}

# Worker Fedora CoreOS config
data "template_file" "worker-config" {
  count    = var.worker_count
  template = file("${path.module}/fcc/worker.yaml")

  vars = {
    cluster_dns_service_ip = cidrhost(var.service_cidr, 10)
    cluster_domain_suffix  = var.cluster_domain_suffix
    ssh_keys               = yamlencode(var.ssh_keys)
    node_private_ip        = cidrhost(var.node_cidr, 20+count.index) # Reserve 10.x.x.2-10.x.x.19 for Control Nodes
    node_cidr_netmask      = split("/", var.node_cidr)[1]
  }
}
