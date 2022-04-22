# Overview
 Deplying a Kubernetes Cluster in Azure with the AKS service.
 - Build a Kubernetes cluster in Azure
 - Have the cluster setup to automatically scale with load
 - Have Kubeconfig file available so it can be managed, changed, altered, destroyed, etc.
 - Ensure Kubeconfig file is secure, and is being encrypted with traffic involved in this

# Steps to do this
1. Have an Azure account; *if you are a student, sign up for a student account and get some free credits along side it.*
2. Setup Terraform files for the deployment
3. Keep track of Terraform State and Kubeconfig files in order to continue managaing deployed resources

# Terraform Process
## Setting up Providers; Azurerm & Kubernetes
Create a file named provider.tf <br> I personally use the Azure CLI, this guide will be based on that. Use `az login` to connect to your Azure resources. Refer to [Microsoft's documentation for Azure CLI](https://docs.microsoft.com/en-us/cli/azure/get-started-with-azure-cli). For Terraform, we are using the [Azurerm, and Kubernetes Poviders](https://registry.terraform.io/browse/providers)

```tf
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
```

## Setting up the Kubernetes structure
Create a file nameed cluster.tf. <br> Within this file, we will define required networking and cluster resources/data parameters. 

```tf
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
```

## Assigning variables for Terraform
Create a file named variables.tf. <br> Generally, these variables within the file are ready to go. Ensure the public key is pointing to your SSH key. 

```tf
variable "cluster_name" {
  default = "terraformclust"
}

variable "cluster_nodes_count" {
  default = "2"
}

variable "region" {
  default = "East US 2"
}

variable "prefix" {
  default = "az-ter"
}

variable "ssh_public_key"{
  default = "./id_rsa.pub"
}
```

## Creating outputs to be sent back after Terraform finishes running
Create a file named output.tf. <br> Certain parts of the output file are critical to get access to the cluster once it is spun up. Specifically the cluster_name, and resource_group_name outputs are essential.These will be used in order to obtain kubectl access for managing the cluster. I included a few extra output resources for future usage. 

```tf
output "client_key" {
  value = azurerm_kubernetes_cluster.cluster.kube_config.0.client_key
  sensitive = true
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate
  sensitive = true
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate
  sensitive = true
}

output "cluster_username" {
  value = azurerm_kubernetes_cluster.cluster.kube_config.0.username
  sensitive = true
}

output "cluster_password" {
  value = azurerm_kubernetes_cluster.cluster.kube_config.0.password
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.cluster.kube_config_raw
  sensitive = true
}

output "host" {
  value = azurerm_kubernetes_cluster.cluster.kube_config.0.host
  sensitive = true
}

# Critical to get kubectl file connected out to Azure for local environment
output "cluster_name" {
  value = azurerm_kubernetes_cluster.cluster.name
}

output "resource_group_name" {
  value = azurerm_resource_group.cluster.name
}


```

## Gain access to Kubectl
In order to gain access from your local machine, we will use the azure CLI. If you followed the tutorial, you'll already be logged in, `az login`. Use the following command to set your environment varialbe for kubectl to control kubernetes cluster in Azure.
`az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw cluster_name)`

Once ran, you can verify it is connected and working with `kubectl get nodes` , `kubectl get namespace`
# Useful Resources
* [Kubernetes Overview](https://learnk8s.io/terraform-aks)
* [Terraform Kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest)
* [Terraform Azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
