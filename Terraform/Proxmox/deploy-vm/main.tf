terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = ">=2.9.6"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.PM_URL
  pm_user    = var.PM_USER
  pm_password    = var.PM_PASS
}

/* Enable Debug Mode
provider "proxmox" {
  pm_debug = true
}
*/

/* Enable Logs 
provider "proxmox" {
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_debug      = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}
*/