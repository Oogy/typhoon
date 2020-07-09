module "bootstrap" {
  source            = "git::https://github.com/poseidon/terraform-render-bootstrap.git?ref=9a5132b2ad199ccb87e69b1b203cbb3caa9a755e"
  cluster_name      = var.cluster_name
  api_servers       = formatlist("%s.%s", vultr_dns_record.controllers.*.name, vultr_dns_domain.dns_zone.domain)
  etcd_servers      = formatlist("%s.%s", vultr_dns_record.etcds.*.name, vultr_dns_domain.dns_zone.domain)
  networking        = var.networking
  pod_cidr          = var.pod_cidr
  trusted_certs_dir = "/etc/pki/tls/certs"
}
