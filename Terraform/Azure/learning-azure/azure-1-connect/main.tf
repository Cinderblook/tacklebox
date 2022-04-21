terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "TF_azure" {
  name     = "TF-resources"
  location = "East US"
}

# Module for configuring VM in Azure
module "linuxservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.TF_azure.name
  vm_os_simple        = "UbuntuServer"
  public_ip_dns       = ["linsimplevmipss"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]
  vm_size             = "Standard_B1ls"
  depends_on = [azurerm_resource_group.TF_azure]
}
output "linux_vm_public_name" {
  value = module.linuxservers.public_ip_dns_name
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.TF_azure.name
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]

  depends_on = [azurerm_resource_group.TF_azure]
}


