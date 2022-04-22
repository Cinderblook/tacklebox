# Resource Group for Terraform deployment
resource "azurerm_resource_group" "cluster" {
  name     = "${var.prefix}-cluster"
  location = var.region
}

# Networking Setup for Cluster
resource "azurerm_virtual_network" "cluster" {
  name                = "${var.prefix}-network"
  location            = azurerm_resource_group.cluster.location
  resource_group_name = azurerm_resource_group.cluster.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "cluster" {
  name                 = "${var.prefix}-subnet"
  virtual_network_name = azurerm_virtual_network.cluster.name
  resource_group_name  = azurerm_resource_group.cluster.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "${var.prefix}-aks"
  location            = azurerm_resource_group.cluster.location
  resource_group_name = azurerm_resource_group.cluster.name
  dns_prefix          = "${var.prefix}-aks"

    linux_profile {
        admin_username = "ubuntu"

        ssh_key {
            key_data = file(var.ssh_public_key)
        }
    }

  default_node_pool {
    name                = "agentpool"
    node_count          = var.cluster_nodes_count
    vm_size             = "Standard_B2s"
    type                = "VirtualMachineScaleSets"
    #availability_zones  = ["1", "2"]
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3

    # Required for advanced networking
    vnet_subnet_id = azurerm_subnet.cluster.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = "Development"
  }
}
# Required to be pushed into Kubernetes Provid`er in provider.tf
data "azurerm_kubernetes_cluster" "credneitals" {
  name                = azurerm_kubernetes_cluster.cluster.name
  resource_group_name = azurerm_resource_group.cluster.name
  depends_on          = [azurerm_kubernetes_cluster.cluster]
}
# This will bring down the required kubeconfig locally to your machine
resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_kubernetes_cluster.cluster]
  filename     = "./kubeconfig"
  content      = azurerm_kubernetes_cluster.cluster.kube_config_raw
}