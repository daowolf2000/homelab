terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "= 3.0.1-rc8"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true

  # pm_log_enable = true
  # pm_log_file   = "telmate.log"
  # pm_debug      = true
  # pm_log_levels = {
  #   _default    = "debug"
  #   _capturelog = ""
  # }
}

