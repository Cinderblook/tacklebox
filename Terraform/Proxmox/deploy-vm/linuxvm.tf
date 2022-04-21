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
