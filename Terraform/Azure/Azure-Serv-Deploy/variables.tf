variable "winserv_vm_os_publisher" {}
variable "winserv_vm_os_offer" {}
variable "winserv_vm_os_sku" {}
variable "winserv_vm_size" {}
variable "winadmin_username" {}
variable "winadmin_password" {}
variable "winserv_license" {}
variable "winserv_sa_type" {}
variable "winserv_pdc" {}
variable "winserv_rdc" {} 
variable "winserv_dhcp" {} 
variable "winserv_file" {}    
variable "linux_server" {}
variable "linux_vm_os_publisher" {}
variable "linux_vm_os_offer" {}
variable "linux_vm_os_sku" {}
variable "linux_vm_size" {}
variable "linux_ssh_key" {}
variable "linux_sa_type" {}
variable "linux_ssh_key_pv" {}
variable "winserv_allocation_method" {}
variable "east_address_spaces" {}
variable "east_subnets" {}
variable "winserv_public_ip_sku" {}
variable "winserv1_private_ip" {}
variable "winserv2_private_ip" {}
variable "winserv3_private_ip" {}
variable "winserv4_private_ip" {}
variable "linux1_priavte_ip" {}

locals{
    first_logon_commands        = file("${path.module}/winfiles/FirstLogonCommands.xml")
    auto_logon                  = "<AutoLogon><Password><Value>${var.winadmin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.winadmin_username}</Username></AutoLogon>"
}