variable "cluster_name" {
  type        = string
  description = "Unique cluster name (prepended to dns_zone)"
}

# Vultr

variable "cluster_region" {
  type        = string
  description = "Vultr region code (e.g. ewr, atl, dfw, lax)"
}

variable "dns_zone" {
  type        = string
  description = "Vultr domain (i.e. DNS zone) (e.g. example.com)"
}

# instances

variable "notify_activate" {
  type        = bool
  description = "Send instance activation notification email: (true or false)"
  default     = false
}

variable "autobackup_controllers" {
  type        = bool
  description = "Enable Vultr Auto-backups for Controller instances"
  default     = false
}

variable "controller_count" {
  type        = number
  description = "Number of controllers (i.e. masters)"
  default     = 1
}

variable "worker_count" {
  type        = number
  description = "Number of workers"
  default     = 1
}

variable "controller_type" {
  type        = string
  description = "VC2 type for controllers (e.g. [2048 MB RAM,55 GB SSD,2.00 TB BW], [4096 MB RAM,80 GB SSD,3.00 TB BW], [8192 MB RAM,160 GB SSD,4.00 TB BW])."
  default     = "4096 MB RAM,80 GB SSD,3.00 TB BW"
}

variable "worker_type" {
  type        = string
  description = "VC2 type for workers (e.g. [2048 MB RAM,55 GB SSD,2.00 TB BW], [4096 MB RAM,80 GB SSD,3.00 TB BW], [8192 MB RAM,160 GB SSD,4.00 TB BW])."
  default     = "2048 MB RAM,55 GB SSD,2.00 TB BW"
}

variable "os_image" {
  type        = string
  description = "Fedora CoreOS image for instances"
  default     = "Fedora CoreOS"
}

variable "controller_snippets" {
  type        = list(string)
  description = "Controller Fedora CoreOS Config snippets"
  default     = []
}

variable "worker_snippets" {
  type        = list(string)
  description = "Worker Fedora CoreOS Config snippets"
  default     = []
}

# configuration

variable "ssh_keys" {
  type        = list(string)
  description = "SSH public keys"
}

variable "networking" {
  type        = string
  description = "Networking provider (flannel)"
  default     = "flannel"
}

variable "node_cidr" {
  type        = string
  description = "CIDR IPv4 range to assign to Kubernetes controller nodes"
  default     = "10.1.0.0/16"
}

variable "pod_cidr" {
  type        = string
  description = "CIDR IPv4 range to assign Kubernetes pods"
  default     = "10.244.0.0/16"
}

variable "service_cidr" {
  type        = string
  description = <<EOD
CIDR IPv4 range to assign Kubernetes services.
The 1st IP will be reserved for kube_apiserver, the 10th IP will be reserved for coredns.
EOD
  default     = "10.3.0.0/16"
}

variable "enable_aggregation" {
  type        = bool
  description = "Enable the Kubernetes Aggregation Layer (defaults to false)"
  default     = false
}

variable "cluster_domain_suffix" {
  type        = string
  description = "Queries for domains with the suffix will be answered by coredns. Default is cluster.local (e.g. foo.default.svc.cluster.local) "
  default     = "cluster.local"
}

variable "asset_dir" {
  type        = string
  description = "Absolute path to a directory where generated assets should be placed (contains secrets)"
  default     = ""
}
