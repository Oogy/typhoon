data "vultr_region" "cluster_region" {
  filter {
    name   = "regioncode"
    values = [upper(var.cluster_region)]
  }
}

data "vultr_plan" "controller_type" {
  filter {
    name   = "name"
    values = [var.controller_type]
  }
}

data "vultr_plan" "worker_type" {
  filter {
    name   = "name"
    values = [var.worker_type]
  }
}

data "vultr_os" "os_image" {
  filter {
    name   = "name"
    values = [var.os_image]
  }
}


