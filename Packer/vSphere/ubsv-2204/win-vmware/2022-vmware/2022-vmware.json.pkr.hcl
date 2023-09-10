packer {
  required_plugins {
    windows-update = {
      version = "0.14.3"
      source = "github.com/rgl/windows-update"
    }
  }
}

source "vsphere-iso" "vmw2022" {
  CPU_hot_plug         = true
  CPUs                 = 2
  RAM                  = 4096
  RAM_hot_plug         = true
  RAM_reserve_all      = false
  boot_command         = ["<down><down><enter><wait><enter>"]
  boot_wait            = "20s"
  communicator         = "winrm"
  cluster              = "${var.vcenter_cluster}"
  datacenter           = "${var.vcenter_datacenter}"
  datastore            = "${var.vcenter_datastore}"
  disk_controller_type = ["pvscsi"]
  firmware             = "efi-secure"
  floppy_files         = [
    "Autounattend.xml", 
    "../common-files/files/bootstrap-win-vmware.ps1"
  ]
  force_bios_setup     = true
  guest_os_type        = "windows2019srv_64Guest"
  http_directory       = "../common-files/files"
  http_port_max        = 8030
  http_port_min        = 8020
  insecure_connection  = "true"
  iso_paths            = [
    "${var.vcenter_iso_path}",
    "${var.vcenter_vmtools_iso_path}",
  ]
  network_adapters {
    network      = "${var.vcenter_network}"
    network_card = "vmxnet3"
  }
  password         = "${var.vcenter_password}"
  shutdown_command = "c:\\windows\\system32\\shutdown.exe /s /f /t 30"
  shutdown_timeout = "30m"
  storage {
    disk_size             = 51200
    disk_thin_provisioned = true
  }
  username       = "${var.vcenter_user}"
  vcenter_server = "${var.vcenter_server}"
  vm_name        = "${var.hostname}"
  winrm_password = "${var.password}"
  winrm_port     = "5985"
  winrm_timeout  = "2h"
  winrm_username = "administrator"
}

build {
  sources = ["source.vsphere-iso.vmw2022"]

  provisioner "windows-update" {
    filters         = ["exclude:$_.Title -like '*Preview*'", "include:$true"]
    search_criteria = "IsInstalled=0"
  }

  provisioner "powershell" {
    elevated_password = "${var.password}"
    elevated_user     = "administrator"
    inline            = [
      "$user = [ADSI]\"WinNT://$env:ComputerName/administrator,user\"",
      "$user.PasswordExpired = 1",
      "$user.SetInfo()"
    ]
  }

}
