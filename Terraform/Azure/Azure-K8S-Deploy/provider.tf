terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.2"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host        = data.azurerm_kubernetes_cluster.credneitals.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.credneitals.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.credneitals.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.credneitals.kube_config.0.cluster_ca_certificate)

}
