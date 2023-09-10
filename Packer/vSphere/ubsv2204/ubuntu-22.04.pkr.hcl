variable "vcenter_username" {
  type    = string
  description = "The username for authenticating to vCenter."
  default = ""
  sensitive = true
}

variable "vcenter_password" {
  type    = string
  description = "The plaintext password for authenticating to vCenter."
  default = ""
  sensitive = true
}

variable "ssh_username" {
  type    = string
  description = "The username to use to authenticate over SSH."
  default = ""
  sensitive = true
}

variable "ssh_password" {
  type    = string
  description = "The plaintext password to use to authenticate over SSH."
  default = ""
  sensitive = true
}

# vSphere Objects

variable "vcenter_insecure_connection" {
  type    = bool
  description = "If true, does not validate the vCenter server's TLS certificate."
  default = true
}

variable "vcenter_server" {
  type    = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance."
  default = ""
}

variable "vcenter_datacenter" {
  type    = string
  description = "Required if there is more than one datacenter in vCenter."
  default = ""
}

variable "vcenter_host" {
  type = string
  description = "The ESXi host where target VM is created."
  default = ""
}

variable "vcenter_cluster" {
  type = string
  description = "The cluster where target VM is created."
  default = ""
}

variable "vcenter_datastore" {
  type    = string
  description = "Required for clusters, or if the target host has multiple datastores."
  default = ""
}

variable "vcenter_network" {
  type    = string
  description = "The network segment or port group name to which the primary virtual network adapter will be connected."
  default = ""
}

variable "vcenter_folder" {
  type    = string
  description = "The VM folder in which the VM template will be created."
  default = ""
}

# ISO Objects

variable "iso_path" {
  type    = string
  description = "The path on the source vSphere datastore for ISO images."
  default = ""
  }

variable "iso_url" {
  type    = string
  description = "The url to retrieve the iso image"
  default = ""
  }

variable "iso_file" {
  type = string
  description = "The file name of the guest operating system ISO image installation media."
  default = ""
}

variable "iso_checksum" {
  type    = string
  description = "The checksum of the ISO image."
  default = ""
}

variable "iso_checksum_type" {
  type    = string
  description = "The checksum type of the ISO image. Ex: sha256"
  default = ""
}

# HTTP Endpoint

variable "http_directory" {
  type    = string
  description = "Directory of config files(user-data, meta-data)."
  default = ""
}

# Virtual Machine Settings

variable "vm_name" {
  type    = string
  description = "The template vm name"
  default = ""
}

variable "vm_guest_os_type" {
  type    = string
  description = "The guest operating system type, also know as guestid."
  default = ""
}

variable "vm_version" {
  type = number
  description = "The VM virtual hardware version."
  # https://kb.vmware.com/s/article/1003746
}

variable "vm_firmware" {
  type    = string
  description = "The virtual machine firmware. (e.g. 'bios' or 'efi')"
  default = ""
}

variable "vm_cdrom_type" {
  type    = string
  description = "The virtual machine CD-ROM type."
  default = ""
}

variable "vm_cpu_sockets" {
  type = number
  description = "The number of virtual CPUs sockets."
}

variable "vm_cpu_cores" {
  type = number
  description = "The number of virtual CPUs cores per socket."
}

variable "vm_mem_size" {
  type = number
  description = "The size for the virtual memory in MB."
}

variable "vm_disk_size" {
  type = number
  description = "The size for the virtual disk in MB."
}

variable "thin_provision" {
  type = bool
  description = "Thin or Thick provisioning of the disk"
}

variable "disk_eagerly_scrub" {
  type = bool
  description = "eagrly scrub zeros"
  default = false
}

variable "vm_disk_controller_type" {
  type = list(string)
  description = "The virtual disk controller types in sequence."
}

variable "vm_network_card" {
  type = string
  description = "The virtual network card type."
  default = ""
}

variable "vm_boot_wait" {
  type = string
  description = "The time to wait before boot. "
  default = ""
}

variable "shell_scripts" {
  type = list(string)
  description = "A list of scripts."
  default = []
}

##################################################################################
# LOCALS
##################################################################################

locals {
  buildtime = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
}

##################################################################################
# SOURCE
##################################################################################

source "vsphere-iso" "linux-ubuntu-server" {
  vcenter_server = var.vcenter_server
  username = var.vcenter_username
  password = var.vcenter_password
  datacenter = var.vcenter_datacenter
  datastore = var.vcenter_datastore
  host = var.vcenter_host
  cluster = var.vcenter_cluster
  folder = var.vcenter_folder
  insecure_connection = var.vcenter_insecure_connection
  tools_upgrade_policy = true
  remove_cdrom = true
  convert_to_template = true
  guest_os_type = var.vm_guest_os_type
  vm_version = var.vm_version
  notes = "Built by HashiCorp Packer on ${local.buildtime}."
  vm_name = var.vm_name
  firmware = var.vm_firmware
  CPUs = var.vm_cpu_sockets
  cpu_cores = var.vm_cpu_cores
  CPU_hot_plug = false
  RAM = var.vm_mem_size
  RAM_hot_plug = false
  cdrom_type = var.vm_cdrom_type
  disk_controller_type = var.vm_disk_controller_type
  storage {
    disk_size = var.vm_disk_size
    disk_controller_index = 0
    disk_thin_provisioned = var.thin_provision
    disk_eagerly_scrub = var.disk_eagerly_scrub
  }
  network_adapters {
    network = var.vcenter_network
    network_card = var.vm_network_card
  }
  iso_url = var.iso_url
  // iso_paths = ["[${ var.vcenter_datastore }] /${ var.iso_path }/${ var.iso_file }"]
  iso_checksum = "${var.iso_checksum_type}:${var.iso_checksum}"
  http_directory = var.http_directory
  boot_order = "disk,cdrom"
  boot_wait = var.vm_boot_wait
  cd_files = [
        "./${var.http_directory}/meta-data",
        "./${var.http_directory}/user-data"]
  cd_label = "cidata"
  boot_command         = [

    "e<wait><down><down><down><end>", 

    " autoinstall ip=192.168.1.52::192.168.1.1:255.255.255.0::::1.1.1.1 'ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'", 

    "<wait><F10><wait>"

  ]
  ip_wait_timeout = "20m"
  ssh_password = var.ssh_password
  ssh_username = var.ssh_username
  ssh_port = 22
  ssh_timeout = "30m"
  ssh_handshake_attempts = "100"
  shutdown_command = "echo '${var.ssh_password}' | sudo -S -E shutdown -P now"
  shutdown_timeout = "15m"
}

##################################################################################
# BUILD
##################################################################################

build {
  sources = [
    "source.vsphere-iso.linux-ubuntu-server"]
  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    environment_vars = [
      "BUILD_USERNAME=${var.ssh_username}",
    ]
    scripts = var.shell_scripts
    expect_disconnect = true
  }
 }
