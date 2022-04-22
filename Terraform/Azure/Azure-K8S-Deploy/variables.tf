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