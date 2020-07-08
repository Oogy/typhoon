module "vultr" {
  source                 = "../kubernetes"
  cluster_region         = "ewr"
  cluster_name           = "vultr-dev"
  dns_zone               = "vultr-dev"
  autobackup_controllers = false
  notify_activate        = false
  ssh_keys               = [file("/home/dev/.ssh/id_rsa.pub")]
}
