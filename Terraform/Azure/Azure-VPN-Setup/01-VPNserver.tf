resource "azurerm_linux_virtual_machine" "vpn" {
  name                = var.linux_server
  resource_group_name = azurerm_resource_group.vpn_server.name
  location            = azurerm_resource_group.vpn_server.location
  size                = var.linux_vm_size
  admin_username      = var.linux_username
  network_interface_ids = [
    azurerm_network_interface.myvpn_linux.id
  ]

  admin_ssh_key {
    username   = var.linux_username
    public_key = file("${var.linux_ssh_key}")
  }

  # Cloud-Init passed here
  custom_data = data.template_cloudinit_config.config.rendered

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.linux_sa_type
  }

  source_image_reference {
    publisher = var.linux_vm_os_publisher
    offer     = var.linux_vm_os_offer
    sku       = var.linux_vm_os_sku
    version   = "latest"
  }
  depends_on = [azurerm_resource_group.vpn_server, azurerm_network_interface.myvpn_linux]
}

# Create cloud-init file to be passed into linux vm
data "template_file" "user_data" {
  template = file("./cloudinit_config.yml")
}

# Render a multi-part cloud-init config making use of the part
# above, and other source files
data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.user_data.rendered}"
  }
}
