# Provider config

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.60.0"
    }
    azapi = {
      source = "Azure/azapi"
      version = "1.6.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}

# Due to issue with new azurerm_linux_web_app not supportinig Docker-Compose injections, 
# have to use this module to update web_app post deployment
provider "azapi" {
}
