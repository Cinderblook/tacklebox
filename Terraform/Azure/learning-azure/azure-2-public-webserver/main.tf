#GUIDE FOR SETUP MINUS LOCAL AUTHENTICATION: https://medium.com/@jorge.gongora2610/how-to-set-up-an-apache-web-server-on-azure-using-terraform-f7498daa9d66
#INFO FROM MICROSOFT: https://docs.microsoft.com/en-us/azure/developer/terraform/configure-vs-code-extension-for-terraform?tabs=azure-cli
terraform {

  required_version = ">=0.12"
  
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

#Setup Resource group for Azure isntance
resource "azurerm_resource_group" "rg01" {
  name     = resource_group_name_prefix
  location = active_rg_region
}

# Create a virtual private cloud network within the resource group
resource "azurerm_virtual_network" "vpcnetwork01" {
  name                = "rg01-vpcnetwork01"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  address_space       = var.vpc_cidr
}

# Create a subnet for the Virtual Network to be used
resource "azurerm_subnet" "vpcsubnet01" {
  name = "rg01-vpcsubnet01"
  virtual_network_name = azurerm_virtual_network.vpcnetwork01.name
  resource_group_name = azurerm_virtual_network.location.name
  address_prefixes = var.public_subnet_cidr
}

# Assign a Public IP address for outward communication
resource "azurerm_public_ip" "publicip01" {
  name = "rg01-publicip01"
  location = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method = "Dynamic"
  domain_name_label = "terravm01"
}

# Create security group to associate with VPC Subnet
resource "azurerm_network_security_group" "rg01-sg01" {
  nane = "rg01-sg01"
  location = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name

  security_rule {
    #HTTP
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    #HTTPS Setup
    name                       = "HTTPS"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    #SSH Setup
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create the network interface associated to networking defined above
resource "azurerm_network_interface" "rg01-nic01" {
  name                = "rg01-Nic01"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "rg01-ipconfig"
    subnet_id                     = azurerm_subnet.vpcsubnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip01.id
  }
}

# After Net Config, we must create the VM with OS on it to host webserver
# Setup VM, OS, Disk, Image-Reference, & Setup commands 
resource "azurerm_virtual_machine" "vm01" {
  name                = "vm01-site"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  vm_size             = var.vm_size

  network_interface_ids         = ["${azurerm_network_interface.rg01_nic01.id}"]
  delete_os_disk_on_termination = "true"

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  storage_os_disk {
    name              = "vm01_osdisk"
    managed_disk_type ="Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name = "vm01"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = "true"
    ssh_keys  {
      path     = "/home/${var.admin_usernam}/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub") 
    }
  }

  # Ensure SSH comes up Prior to setup of Web Server
    provisioner "remote-exec" {
      inline = [
        "sudo yum -y install httpd && sudo systemctl start httpd",
        "echo '<h1><center>My first website using terraform provisioner</center></h1>' > index.html",
        "echo '<h1><center>Jorge Gongora</center></h1>' >> index.html",
        "sudo mv index.html /var/www/html/"
      ]
      connection {
        type        = "ssh"
        host        = azurerm_public_ip.publicip01.fqdn
        user        = var.admin_username
        private_key = file("~/.ssh/id_rsa")
    }
  }
}



/*resource "random_pet" "rg-name" {
  prefix    = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  name      = random_pet.rg-name.id
  location  = var.active_rg_region
}*/