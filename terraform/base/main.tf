locals {
  lxc_template_os_debian = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
  password               = var.default_password
  ssh_public_keys        = file(var.default_ssh_public_keys)
  network_gw             = "192.168.1.1"
  nameserver             = "192.168.1.1"
  pool                   = "base"
}

resource "proxmox_pool" "base" {
  poolid = local.pool
}


module "mon" {
  source = "../modules/lxc_container"

  hostname   = "mon"
  pool       = local.pool
  ostemplate = local.lxc_template_os_debian

  memory = 4096

  password        = local.password
  ssh_public_keys = local.ssh_public_keys

  network_ip = "192.168.1.12/24"
  network_gw = local.network_gw
  nameserver = local.nameserver

  bind_mounts = [
    {
      volume = "/mnt/lab/apps"
      mp     = "/opt/apps"
      shared = true
    }
  ]
}

module "immich" {
  source = "../modules/lxc_container"

  hostname   = "immich"
  ostemplate = local.lxc_template_os_debian
  tags = [ "gpu" ]
  
  memory = 6144
  swap = 0

  rootfs_size = "20G"

  password        = local.password
  ssh_public_keys = local.ssh_public_keys

  network_ip = "192.168.1.20/24"
  network_gw = local.network_gw
  nameserver = local.nameserver


  bind_mounts = [
    {
      volume = "/mnt/lab/apps"
      mp     = "/opt/apps"
      shared = true
    }
  ]
}

module "gitlab" {
  source = "../modules/lxc_container"

  hostname   = "gitlab"
  ostemplate = local.lxc_template_os_debian
  
  memory = 4096
  swap = 0

  rootfs_size = "40G"

  password        = local.password
  ssh_public_keys = local.ssh_public_keys

  network_ip = "192.168.1.25/24"
  network_gw = local.network_gw
  nameserver = local.nameserver


  bind_mounts = [
    {
      volume = "/mnt/lab/apps"
      mp     = "/opt/apps"
      shared = true
    }
  ]
}

module "ai" {
  source = "../modules/lxc_container"

  hostname   = "ai"
  ostemplate = local.lxc_template_os_debian
  tags = [ "gpu" ]
  
  memory = 16384
  swap = 0

  rootfs_size = "70G"

  password        = local.password
  ssh_public_keys = local.ssh_public_keys

  network_ip = "192.168.1.11/24"
  network_gw = local.network_gw
  nameserver = local.nameserver


  bind_mounts = [
    {
      volume = "/mnt/lab/apps"
      mp     = "/opt/apps"
      shared = true
    }
  ]
}

module "jupyter" {
  source = "../modules/lxc_container"

  hostname   = "jupyter"
  ostemplate = local.lxc_template_os_debian
  tags = [ "gpu" ]
  
  memory = 16384
  swap = 0

  rootfs_size = "20G"

  password        = local.password
  ssh_public_keys = local.ssh_public_keys

  network_ip = "192.168.1.15/24"
  network_gw = local.network_gw
  nameserver = local.nameserver

  features_keyctl = true

  bind_mounts = [
    {
      volume = "/mnt/lab/apps"
      mp     = "/opt/apps"
      shared = true
    }
  ]
}

