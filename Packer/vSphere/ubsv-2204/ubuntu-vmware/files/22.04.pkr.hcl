source "vsphere-iso" "ubuntu_vm" {
  CPUs                 = 2
  RAM                  = 2048
  RAM_reserve_all      = false
  boot_command         = [
    "e<wait><down><down><down><end>", 
    " autoinstall ip=${var.temp_ip}::${var.temp_gw}:${var.temp_mask}::::${var.temp_dns} 'ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'", 
    "<wait><F10><wait>"
  ]
  boot_wait            = "10s"
  cluster              = "${var.vcenter_cluster}"
  datacenter           = "${var.vcenter_datacenter}"
  datastore            = "${var.vcenter_datastore}"
  disk_controller_type = ["pvscsi"]
  firmware             = "efi"
  force_bios_setup     = false
  guest_os_type        = "ubuntu64Guest"
  http_directory       = "subiquity/http"
  http_port_max        = 8030
  http_port_min        = 8020
  insecure_connection  = "true"
  iso_paths            = ["${var.vcenter_iso_path}"]
  network_adapters {
    network      = "${var.vcenter_network}"
    network_card = "vmxnet3"
  }
  password               = "${var.vcenter_password}"
  ssh_handshake_attempts = "200"
  ssh_password           = "${var.password}"
  ssh_pty                = true
  ssh_timeout            = "30m"
  ssh_username           = "${var.username}"
  storage {
    disk_size             = 40960
    disk_thin_provisioned = true
  }
  username       = "${var.vcenter_user}"
  vcenter_server = "${var.vcenter_server}"
  vm_name        = "${var.hostname}"
}

build {
  sources = ["source.vsphere-iso.ubuntu_vm"]

  provisioner "file" {
    destination = "/home/${var.username}/provision.sh"
    source      = "files/provision.sh"
  }

  provisioner "shell" {
    inline = [
      "touch /home/${var.username}/.ssh/authorized_keys"
    ]
  }

  dynamic "provisioner" {
    labels = [ "shell" ]
    iterator = authkey
    for_each = var.ssh_authorized_keys

    content {
      inline = [
        "echo ${authkey.value} | tee -a /home/${var.username}/.ssh/authorized_keys"
      ]
    }
  }

  provisioner "shell" {
    inline = [
      "chmod +x /home/${var.username}/provision.sh", 
      "sudo /home/${var.username}/provision.sh ${var.username}"
    ]
  }

}
