resource "vultr_ssh_key" "keychain" {
  count   = length(var.ssh_keys)
  name    = "${var.cluster_name}-ssh-key-${count.index}"
  ssh_key = var.ssh_keys[count.index]
}

