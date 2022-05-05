#  Setup Cloud-init w/ https://pve.proxmox.com/wiki/Cloud-Init_Support
/* Uses Cloud-Init options from Proxmox 5.2 */
resource "proxmox_vm_qemu" "proxmox_multi_vm" {
  count = "${var.vm_count}"
  name        = "${var.linux_name}-${count.index}"
  desc        = "terraform deploy"
  target_node = "${var.PM_node}"

  clone = var.PM_template

  # The destination resource pool for the new VM
  pool = ""
  ssh_user        = var.ssh_user
  ssh_private_key = var.ssh_priv

  cores   = 1
  sockets = 1
  memory  = 2048
  cpu = "host"

  os_type   = "cloud-init"

  disk {
    size            = "20G"
    type            = "scsi"
    storage         = "datastore"
  }
  network {
    model           = "virtio"
    bridge          = "vmbr0"
  }
  lifecycle {
    ignore_changes  = [
      network,
    ]
  }
  #Cloud-init settings
  ipconfig0 = "ip=${var.linux_ip}${count.index}/${var.linux_subnetmask},gw=${var.linux_gateway}"

  sshkeys = var.ssh_keys

  provisioner "remote-exec" {
    inline = [
      "ip a"
    ]
    connection {
      type = "ssh"
      user = "${var.ssh_user}"
      password = "${var.ssh_pass}"
      host =  "${self.name}" # "${var.linux_name}-${count.index}"
    }
  }
}

