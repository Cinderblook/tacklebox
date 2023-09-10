variable "hostname" { type = string }
variable "password" { 
    type = string
    default = "superP@ss"
}
variable "vcenter_cluster" { type = string }
variable "vcenter_datacenter" { type = string }
variable "vcenter_datastore" { type = string }
variable "vcenter_iso_path" { type = string }
variable "vcenter_vmtools_iso_path" { type = string }
variable "vcenter_network" { type = string }
variable "vcenter_password" { type = string }
variable "vcenter_server" { type = string }
variable "vcenter_user" { type = string }
