resource "vultr_server" "workers" {
  count                  = var.worker_count
  region                 = data.vultr_region.cluster_region.id
  os_id                  = data.vultr_os.os_image.id
  plan_id                = data.vultr_plan.worker_type.id
  label                  = "${var.cluster_name}-worker-${count.index}"
  hostname               = "${var.cluster_name}-worker-${count.index}"
  tag                    = "${var.cluster_name}-worker"
  ssh_keys               = vultr_ssh_key.keychain.*.id
  enable_private_network = true
  network_ids            = [vultr_network.cluster_network.id]
  firewall_group_id      = vultr_firewall_group.cluster_firewall.id
  notify_activate        = var.notify_activate
 #user_data              = data.ct_config.worker-ignitions.*.rendered[count.index]
}
