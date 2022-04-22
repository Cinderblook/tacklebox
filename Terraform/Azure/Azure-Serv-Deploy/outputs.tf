output "Public_IP_Linux" {
    value = azurerm_public_ip.linux_public.ip_address
}
output "Public_IP_Windows" {
    value = azurerm_public_ip.win_public.ip_address
}
output "Private_IP_Linux" {
    value = azurerm_network_interface.linux1.private_ip_address
}

output "Private_IP_WinServ" {
    value = [
        "PDC: ${azurerm_windows_virtual_machine.pdc.private_ip_address}",
        "RDC: ${azurerm_windows_virtual_machine.rdc.private_ip_address}",
        "DHCP: ${azurerm_windows_virtual_machine.dhcp.private_ip_address}",
        "FILE: ${azurerm_windows_virtual_machine.file.private_ip_address}"
        ]
}