variable "resource_group_name_prefix" {
  default       = "test-rg"
  description   = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

#Connection Variables
variable "active_rg_region" {
  description = "Resource location in Azure"
  type    = string
  default = "eastus"
}

#Azure Image Variables
variable "vm_size" {
  description = "Size Standard of VM"
  type        = string
  default     = "Standard_A0"
}
variable "image_publisher" {
  description = "Name of the publisher of the image (az vm image list)"
  default     = "RedHat"
}

variable "image_offer" {
  description = "Name of the offer (az vm image list)"
  default     = "RHEL"
}

variable "image_sku" {
  description = "Image SKU to apply (az vm image list)"
  default     = "7.3"
}

variable "image_version" {
  description = "Version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "admin_username" {
  description = "Admin Creds for machine"
  default     = "administrator"
}

variable "admin_password" {
  description = "Admin Creds for machine"
  default     = "SuperComplex1!!"
}

#Azure Virtual Private Cloud variables
variable "vpc_cidr" {
  description = "Value for Network ID"
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
  description = "Value for public Subnet Network ID"
  type        = string
  default     = "10.0.10.0/24"
}
variable "availability_zone" {
  description = "Value for default availability zone"
  type        = string
  default     = "eastus"
}