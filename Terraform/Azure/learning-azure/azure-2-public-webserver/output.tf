output "resource_group_name" {
    description = "resource group used"
    value = azurerm_resource_group.rg.name
}

output "azurerm_virtual_machine" {
    description = "VM deployed Name"
    value = azurerm_virtual_machine.vm01.name
}

output "azurerm_public_ip" {
    description = "Public IP assigned to VM"
    value = azurerm_public_ip.publicip01.id
}

output "azurerm_subnet" {
    description = "Private Subnet IP assigned to VM"
    value = azurerm_subnet.vpcsubnet01.id
}