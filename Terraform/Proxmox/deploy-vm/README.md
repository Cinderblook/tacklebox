# Overview
Using Terraform to deploy virtual machines in Proxmox. This is designed with Proxmox Virtual Environment version 7.1 in mind. 

# Prequisites
1. Have a [Proxmox](https://www.proxmox.com/en/) server
2. Have a template made on Proxmox, in my case, I used Ubuntu Server 20.04.
3. Have [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed


# Steps
1. Create service user in Proxmox with appropriate settings for Terraform deployments
2. Configure Terraform files & variables for deployment
3. Deploy Terraform

# 1. Configure/Create Terraform User & Role
*This can be also be done under Datacenter-->"Proxmox server" --> Permissions --> Users & Roles in the GUI.*
## Create user and assign it a role
1. SSH into the Proxmox server
2. Create the role in Proxmox with appropriate permissions
   * `pveum role add TerraformProv -privs "VM.Allocate VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.Audit VM.PowerMgmt Datastore.AllocateSpace Datastore.Audit"`
3. Create the user
    * `pveum user add terraform-prov@pve --password <password>`
4. Assign user to the role
    * `pveum aclmod / -user terraform-prov@pve -role TerraformProv`


# 2. Configure Terraform files
This is broken down into 4 files. main.tf, linuxvm.tf, variables.tf, and variables.auto.tfvars.

## Create main.tf file
This file will host Terraform provider information and versioning, along with the connection parameters to your Proxmox server. Put the following into it:
``` tf
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
```

## Create linuxvm.tf file
Contains code to deploy the Virtual Machine. 
``` tf
#  Setup Cloud-init w/ https://pve.proxmox.com/wiki/Cloud-Init_Support
/* Uses Cloud-Init options from Proxmox 5.2 */
resource "proxmox_vm_qemu" "cloudinit-test" {
  name        = var.linux_fqdn
  desc        = "terraform deploy"
  target_node = var.PM_node

  clone = var.PM_template

  # The destination resource pool for the new VM
  pool = ""

  storage = "datastore"
  cores   = 1
  sockets = 1
  memory  = 2048
  disk_gb = 8
  nic     = "virtio"
  bridge  = "vmbr0"

  ssh_user        = "root"
  ssh_private_key = var.ssh_priv

  os_type   = "cloud-init"
  ipconfig0 = "ip=${var.linux_ip}/${var.linux_subnetmask},gw=${var.linux_gateway}"

  sshkeys = var.ssh_keys

  provisioner "remote-exec" {
    inline = [
      "ip a"
    ]
  }
}

```

## Create variables.tf file
Variables declared here, which are defined in the .tfvars file.
``` tf
variable PM_USER {} 
variable PM_PASS {} 
variable "PM_URL" {}
variable "PM_node" {} 
variable "PM_template" {}
variable "ssh_keys" {}
variable "ssh_priv" {}
variable "ssh_user" {} 
variable "linux_fqdn" {}
variable "linux_ip" {}
variable "linux_subnetmask" {}
variable "linux_gateway" {}
```
## Create variables.auto.tfvars file
Put your custom defined variables into this file.
``` tf
# Example .tfvars file
PM_PASS = "proxmox terraform user password"
PM_USER = "proxmox terraform user username"
PM_URL = "https://IPADDRESSorFQDN:8006/api2/json"
PM_node = "target proxmox server name"
PM_template = "target tempalte in Proxmox"
linux_fqdn = "desired name.domain"
linux_ip = "desired IP"
linux_subnetmask = "subnet mask of network" # Should be 24, 26, 30, etc.
linux_gateway = "gateway ip"

ssh_user = "linux username" 

ssh_keys = <<EOF
ssh-rsa key here
ssh-rsa key here
EOF

ssh_priv = <<EOF
-----BEGIN OPENSSH PRIVATE KEY-----
private keye here
-----END OPENSSH PRIVATE KEY----- 
EOF

```

# 3. Deploy terraform
1. Navigate to directory, run `terraform init`
2. `terraform apply --auto-approve`

Check Proxmox server to see VM


3. Destory it with `terraform destroy --auto-approve`

# Useful Resources



