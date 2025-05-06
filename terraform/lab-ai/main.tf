locals {
  lxc_template_os_debian = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
  password               = var.default_password
  ssh_public_keys        = file(var.default_ssh_public_keys)
  network_gw             = "192.168.1.1"
  nameserver             = "192.168.1.1"
}


module "ai" {
  source = "../modules/lxc_container"

  hostname   = "ai"
  ostemplate = local.lxc_template_os_debian
  tags = [ "gpu" ]
  
  memory = 8192

  rootfs_size = "50G"

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
