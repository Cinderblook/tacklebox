# This pulls a Ubuntu Datacenter from Microsoft's VM platform directly
resource "azurerm_linux_virtual_machine" "operator" {
  name                = var.linux_server
  resource_group_name = azurerm_resource_group.east.name
  location            = azurerm_resource_group.east.location
  size                = var.linux_vm_size
  admin_username      = var.winadmin_username
  network_interface_ids = [
    azurerm_network_interface.linux1.id
  ]

  admin_ssh_key {
    username   = var.winadmin_username
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

  depends_on = [azurerm_resource_group.east, azurerm_network_interface.linux1]
}

# Create cloud-init file to be passed into linux vm
data "template_file" "user_data" {
  template = file("./cloudinit/custom.yml")
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

  # Pass Ansible File into created Linux VM using SCP (SSH Port 22)
resource "null_resource" "copyansible"{ 
  connection {
    type        = "ssh"
    host        = azurerm_public_ip.linux_public.ip_address
    user        = var.winadmin_username
    private_key = file("${var.linux_ssh_key_pv}")
  }
  
  provisioner "file" {
    source = "${path.module}/Ansible"
    destination = "/tmp/" 
  }
  depends_on = [azurerm_linux_virtual_machine.operator]
}
