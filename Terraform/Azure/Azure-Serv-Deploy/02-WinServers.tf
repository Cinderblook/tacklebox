# This pulls the latest Windows Server Datacenter from Microsoft's VM platform directly
resource "azurerm_windows_virtual_machine" "pdc" {
  name                = var.winserv_pdc
  resource_group_name = azurerm_resource_group.east.name
  location            = azurerm_resource_group.east.location
  size                = var.winserv_vm_size
  admin_username      = var.winadmin_username
  admin_password      = var.winadmin_password
  network_interface_ids = [
    azurerm_network_interface.winserv1.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.winserv_sa_type
  }

  source_image_reference {
    publisher = var.winserv_vm_os_publisher
    offer     = var.winserv_vm_os_offer
    sku       = var.winserv_vm_os_sku
    version   = "latest"
  }

  additional_unattend_content {
    content = local.auto_logon
    setting = "AutoLogon"
  }

  additional_unattend_content {
    content = local.first_logon_commands
    setting = "FirstLogonCommands"
  }

  depends_on = [azurerm_resource_group.east, azurerm_network_interface.winserv1]
}
resource "azurerm_windows_virtual_machine" "rdc" {
  name                = var.winserv_rdc
  resource_group_name = azurerm_resource_group.east.name
  location            = azurerm_resource_group.east.location
  size                = var.winserv_vm_size
  admin_username      = var.winadmin_username
  admin_password      = var.winadmin_password
  network_interface_ids = [
    azurerm_network_interface.winserv2.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.winserv_sa_type
  }

  source_image_reference {
    publisher = var.winserv_vm_os_publisher
    offer     = var.winserv_vm_os_offer
    sku       = var.winserv_vm_os_sku
    version   = "latest"
  }

  additional_unattend_content {
    content = local.auto_logon
    setting = "AutoLogon"
  }

  additional_unattend_content {
    content = local.first_logon_commands
    setting = "FirstLogonCommands"
  }

  depends_on = [azurerm_resource_group.east, azurerm_network_interface.winserv2]
}
resource "azurerm_windows_virtual_machine" "dhcp" {
  name                = var.winserv_dhcp
  resource_group_name = azurerm_resource_group.east.name
  location            = azurerm_resource_group.east.location
  size                = var.winserv_vm_size
  admin_username      = var.winadmin_username
  admin_password      = var.winadmin_password
  network_interface_ids = [
    azurerm_network_interface.winserv3.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.winserv_sa_type
  }

  source_image_reference {
    publisher = var.winserv_vm_os_publisher
    offer     = var.winserv_vm_os_offer
    sku       = var.winserv_vm_os_sku
    version   = "latest"
  }

  additional_unattend_content {
    content = local.auto_logon
    setting = "AutoLogon"
  }

  additional_unattend_content {
    content = local.first_logon_commands
    setting = "FirstLogonCommands"
  }

  depends_on = [azurerm_resource_group.east, azurerm_network_interface.winserv3]
}
resource "azurerm_windows_virtual_machine" "file" {
  name                = var.winserv_file
  resource_group_name = azurerm_resource_group.east.name
  location            = azurerm_resource_group.east.location
  size                = var.winserv_vm_size
  admin_username      = var.winadmin_username
  admin_password      = var.winadmin_password
  network_interface_ids = [
    azurerm_network_interface.winserv4.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.winserv_sa_type
  }

  source_image_reference {
    publisher = var.winserv_vm_os_publisher
    offer     = var.winserv_vm_os_offer
    sku       = var.winserv_vm_os_sku
    version   = "latest"
  }

  additional_unattend_content {
    content = local.auto_logon
    setting = "AutoLogon"
  }

  additional_unattend_content {
    content = local.first_logon_commands
    setting = "FirstLogonCommands"
  }

  depends_on = [azurerm_resource_group.east, azurerm_network_interface.winserv4]
}

