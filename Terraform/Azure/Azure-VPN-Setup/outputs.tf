output "Public_IP_Linux" {
    value = azurerm_public_ip.myvpn_public.ip_address
}
output "Private_IP_Linux" {
    value = azurerm_network_interface.myvpn_linux.private_ip_address
}
