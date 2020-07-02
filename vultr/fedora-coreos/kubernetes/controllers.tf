resource "vultr_server" "controllers" {
  count                  = var.controller_count
  region                 = data.vultr_region.cluster_region.id
  os_id                  = data.vultr_os.os_image.id
  plan_id                = data.vultr_plan.controller_type.id
  label                  = "${var.cluster_name}-controller-${count.index}"
  hostname               = "${var.cluster_name}-controller-${count.index}"
  tag                    = "${var.cluster_name}-controller"
  ssh_keys               = vultr_ssh_key.keychain.*.id
  enable_private_network = true
  network_ids            = [vultr_network.cluster_network.id]
  firewall_group_id      = vultr_firewall_group.cluster_firewall.id
  notify_activate        = var.notify_activate
  auto_backup            = var.autobackup_controllers
 #user_data              = data.ct_config.controller-ignitions.*.rendered[count.index]
}
