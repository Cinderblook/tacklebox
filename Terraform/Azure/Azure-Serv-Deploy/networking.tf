# Create a resource group to maintain security settings along with network interfaces for VMs
resource "azurerm_resource_group" "east" {
  name     = "terra-resources"
  location = "East US"
}
# ASSIGN ADDRESS SPACE TO RESOURCE GROUP
resource "azurerm_virtual_network" "east" {
  name                = "east-network"
  address_space       = ["${var.east_address_spaces}"]
  location            = azurerm_resource_group.east.location
  resource_group_name = azurerm_resource_group.east.name
}
# ASSIGN SUBNET TO NETWORK ADDRESS SPACE
resource "azurerm_subnet" "subnet1" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.east.name
  virtual_network_name = azurerm_virtual_network.east.name
  address_prefixes     = [var.east_subnets]
}
# Create public IP variable for Linux machine
resource "azurerm_public_ip" "linux_public" {
  name                = "PublicIp1"
  resource_group_name = azurerm_resource_group.east.name
  location            = azurerm_resource_group.east.location
  allocation_method   = "Static"

}
# Create public IP variable for Windows machine
resource "azurerm_public_ip" "win_public" {
  name                = "PublicIp2"
  resource_group_name = azurerm_resource_group.east.name
  location            = azurerm_resource_group.east.location
  allocation_method   = "Static"

}
# ASSIGN NETWORK INTERFACE PER VM WE WILL BE USING
resource "azurerm_network_interface" "linux1" {
  name                = "linux1-nic"
  location            = azurerm_resource_group.east.location
  resource_group_name = azurerm_resource_group.east.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.linux1_priavte_ip    
    public_ip_address_id          = azurerm_public_ip.linux_public.id
  }
}
resource "azurerm_network_interface" "winserv1" {
  name                = "winserv1-nic"
  location            = azurerm_resource_group.east.location
  resource_group_name = azurerm_resource_group.east.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.winserv1_private_ip
    public_ip_address_id          = azurerm_public_ip.win_public.id
  }
}
resource "azurerm_network_interface" "winserv2" {
  name                = "winserv2-nic"
  location            = azurerm_resource_group.east.location
  resource_group_name = azurerm_resource_group.east.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.winserv2_private_ip
  }
}
resource "azurerm_network_interface" "winserv3" {
  name                = "winserv3-nic"
  location            = azurerm_resource_group.east.location
  resource_group_name = azurerm_resource_group.east.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.winserv3_private_ip
  }
}
resource "azurerm_network_interface" "winserv4" {
  name                = "winserv4-nic"
  location            = azurerm_resource_group.east.location
  resource_group_name = azurerm_resource_group.east.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.winserv4_private_ip
  }
}
# CREATE SECURITY GROUPs TO ALLOW SSH/RDP/ANSIBLE FOR VMs
resource "azurerm_network_security_group" "linux1" {
  name                = "Allow-SSH"
  location            = azurerm_resource_group.east.location
  resource_group_name = azurerm_resource_group.east.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_security_group" "winserv" {
  name                = "Allow-RDP-SSH-ANS"
  location            = azurerm_resource_group.east.location
  resource_group_name = azurerm_resource_group.east.name
  security_rule {
    name                       = "RDP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
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
   security_rule {
    name                       = "ANSIBLE"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "${var.east_subnets}"
    destination_address_prefix = "*"
  }
}
# ASSIGN SECURITY GROUPS TO INTERFACES
# LINUX SSH
resource "azurerm_network_interface_security_group_association" "linux1" {
  network_interface_id      = azurerm_network_interface.linux1.id
  network_security_group_id = azurerm_network_security_group.linux1.id
}
# WINSERV RDP
resource "azurerm_network_interface_security_group_association" "winserv1" {
  network_interface_id      = azurerm_network_interface.winserv1.id
  network_security_group_id = azurerm_network_security_group.winserv.id
}
resource "azurerm_network_interface_security_group_association" "winserv2" {
  network_interface_id      = azurerm_network_interface.winserv2.id
  network_security_group_id = azurerm_network_security_group.winserv.id
}
resource "azurerm_network_interface_security_group_association" "winserv3" {
  network_interface_id      = azurerm_network_interface.winserv3.id
  network_security_group_id = azurerm_network_security_group.winserv.id
}
resource "azurerm_network_interface_security_group_association" "winserv4" {
  network_interface_id      = azurerm_network_interface.winserv4.id
  network_security_group_id = azurerm_network_security_group.winserv.id
}


