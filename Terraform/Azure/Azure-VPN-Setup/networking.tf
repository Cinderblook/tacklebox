# Create a resource group to maintain security settings along with network interfaces for VMs
resource "azurerm_resource_group" "vpn_server" {
  name     = "myvpn-resources"
  location = "East US"
}
# ASSIGN ADDRESS SPACE TO RESOURCE GROUP
resource "azurerm_virtual_network" "vpn_server" {
  name                = "vpn-server-network"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.vpn_server.location
  resource_group_name = azurerm_resource_group.vpn_server.name
}
# ASSIGN SUBNET TO NETWORK ADDRESS SPACE
resource "azurerm_subnet" "myvpn_subnet" {
  name                 = "vpnsubnet"
  resource_group_name  = azurerm_resource_group.vpn_server.name
  virtual_network_name = azurerm_virtual_network.vpn_server.name
  address_prefixes     = ["192.168.10.0/24"]
}
# Create public IP variable for Linux machine
resource "azurerm_public_ip" "myvpn_public" {
  name                = "myvpn-PublicIp"
  resource_group_name = azurerm_resource_group.vpn_server.name
  location            = azurerm_resource_group.vpn_server.location
  allocation_method   = "Static"

}
# ASSIGN NETWORK INTERFACE PER VM WE WILL BE USING
resource "azurerm_network_interface" "myvpn_linux" {
  name                = "myvpn-nic"
  location            = azurerm_resource_group.vpn_server.location
  resource_group_name = azurerm_resource_group.vpn_server.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.myvpn_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.myvpn_linux_priavte_ip    
    public_ip_address_id          = azurerm_public_ip.myvpn_public.id
  }
}
# Assignign network sec grp in Azure
resource "azurerm_network_security_group" "myvpn_linux" {
  name                = "VPN-Ports"
  location            = azurerm_resource_group.vpn_server.location
  resource_group_name = azurerm_resource_group.vpn_server.name
  #security_rule { #RDP
  #  name                       = "RDP"
  #  priority                   = 101
  #  direction                  = "Inbound"
  #  access                     = "Allow"
  #  protocol                   = "Tcp"
  #  source_port_range          = "*"
  #  destination_port_range     = "3389"
  #  source_address_prefix      = "*"
  #  destination_address_prefix = "*"
  #}
  security_rule { #SSH
    name                       = "SSH"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule { #HTTPS
   name                       = "HTTPS"
   priority                   = 103
   direction                  = "Inbound"
   access                     = "Allow"
   protocol                   = "Tcp"
   source_port_range          = "*"
   destination_port_range     = "443"
   source_address_prefix      = "*"
   destination_address_prefix = "*"
  }
  security_rule { #OpenVPN
    name                       = "OpenVPN"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "1194"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  } 
  security_rule { #OpenVPN
    name                       = "OpenVPNsite"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "943"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}
}
# ASSIGN SECURITY GROUPS TO INTERFACES
# LINUX SSH
resource "azurerm_network_interface_security_group_association" "myvpn_linux" {
  network_interface_id      = azurerm_network_interface.myvpn_linux.id
  network_security_group_id = azurerm_network_security_group.myvpn_linux.id
}