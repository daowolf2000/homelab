

module "base-gpu" {
  source = "../modules/lxc_container"

  hostname   = "base-gpu"
  pool       = local.pool
  ostemplate = local.lxc_template_os_debian

  memory = 2048

  password        = local.password
  ssh_public_keys = local.ssh_public_keys

  network_ip = "dhcp"
  network_gw = local.network_gw
  nameserver = local.nameserver
}

# resource "lxc_container" "base-gpu" {
#   hostname   = "base-gpu"
#   ostemplate = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
#   cores      = 2
#   memory     = 2048
#   rootfs {
#     storage = "local-lvm"
#     size    = "8G"
#   }
#   network {
#     name   = "eth0"
#     bridge = "vmbr0"
#     ip     = "dhcp"
#   }
# }

resource "null_resource" "gpu_passthru" {
  depends_on = [module.base-gpu]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook daowolf2000.proxmox.lxc_nvidia_passthru -i ../../hosts/proxmox.yml -e target=base-gpu"
  }
}

resource "null_resource" "ansible_configure" {
  depends_on = [null_resource.gpu_passthru]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ../../plays/deploy.yml -e target=base-gpu.yml"
  }
}

resource "null_resource" "convert_to_template" {
  depends_on = [null_resource.ansible_configure]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook daowolf2000.proxmox.lxc_convert_to_template -i ../../hosts/proxmox.yml -e vmid=${module.base-gpu.vmid}"
  }
}

# resource "proxmox_lxc" "test_clone" {
#   depends_on = [null_resource.ansible_configure]

#   target_node = "pve"
#   hostname    = "test_clone"
#   ostemplate = "local-lvm:vzt"
  
# }


output "base_vmid" {
  value = module.base-gpu.vmid
}