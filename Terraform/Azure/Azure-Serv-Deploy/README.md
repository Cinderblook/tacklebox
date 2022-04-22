# Overview

Deploy and Configure 4 Windows 2022 Datacenter Servers in Azure.
- Using Terraform in conjunction with Ansible: Create 4 Windows Servers
  - Configure them to be a Primary Domain Controller, Replica Domain Controller, DHCP server, and Fileshare server    
  - Automate intial setup of the 4 servers to accept Ansible configuration from a Linux VM in Azure created VIA the Terraform deployment

# Terraform
Main role: Deploy the Virtual Machines, setup Network environment, and provide intial parameters for both Windows and Linux environments running in the cloud
-   Setup the four Windows Servers (Primary Domain Controller, Replica Domain Controller, DHCP, Fileshare) in Azure
    - These will all be Windows 2022 Datacenter Servers running on Standard_DS1_V2 by default
-   Setup the one Linux server to deploy a pre-defined Ansible configuration across the Windows Environment for setting up Active Directory, DHCP, File shares, users, and groups.
    - This will all be an Ubuntu 18.04-LTS server running on Standard_B1s by default
    - It will use cloud-init to supply it the necessary setup at creation for Ansible and SSH connection VIA its public IP address.
-   Supply necessary networking variables (Network interfaces, Security Groups, IP Addressing)
-   Supply necessary files for automation of Windows & Linux environments (Cloud-Init & Windows Unattend files)

<br>

## Prerequisites
- Setup necessary Terraform [environment](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Install and setup [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) or preferred method of authentication to Azure
- Configure variables for desired outcomes (Outlined further down)
<br>

## Terraform process
- Using the Azure provider:
    - Login to Azure with `az connect`
- Once prepared with appropriate values and the networking is in place: 
    - Navigate to the Terraform directory and run these commands
    - `terraform init` Pull proper Terraform providers and modules used
    - `terraform validate` This will return whether the configuration is valid or not
    - `terraform apply` ... `yes` Actually apply the configuration

## Terraform File Structure

###  *provider.tf* File
- Calls necessary providers and sets their versions to be used in the Terraform configuration/deployment
###  *networking.tf* File
- Defines resources, security groups, security rules, network interfaces, subnets, and public IPs to be created in Azure. 
    - These variables are pulled from the VM creation resources
    - Managed with variables contained in terraform.tfvars file

###  *variables.tf, terraform.tfvars* Files
-  Alter variables within these files to ensure they meet your environment needs
    - *variables.tf*
        - Declare variables that will be used with the Terraform configuration (Delcared intially or explicitely here as `locals` variables)
            - *firsT_logon_commands* local variable points to a .xml file to configure first time logon in Windows. This enables each server to recieve Winrm data on port 5985 for Ansible configuration
            - *auto_logon_ runs a .xml configuration to log in once right after intial creation of VM. This allows *first_logon_commands* to execute automatically
    - *terraform.tfvars*
        - Assign variables values here. These will be used with the Terraform configuration. If left blank, you can assign the variable at the terminal level when running the `terraform apply` 
            - Alter Network values to desired IP addressing scheme
                -  **Ensure IP addressing matches that in the Ansible configuration inventory.yml**
            - Here you can alter azure values for _publisher_, _offer_, _sku_, _size_, _sa_, and _license_ information for the Windows/Linux VMs
            - Additionally, ensure `linux_ssh_key` point to your public Key `id_rsa.pubc` file
            - I recommend to change _winadmin_username_ & _winadmin_password_ variables to sensetive and blank so you can delcare them in preferrably Vaulty or via the CLI 
                - **_winadmin_username_ & _winadmin_password_ MUST MATCH WHAT IS IN ANSIBLE /group_vars/all.yml**

### *01-LinuxClient.tf* & *02-WinServers.tf* Files
- Here the creation of the VMs occur. Resources pull data from _networking.tf_, _variables.tf_, _terraform.tfvars_ files.
    - Windows VMs are assigned unattend configurations for first time setup (/winfiles/FirstLogonCommands.xml && _auto_logon_ variable data)
    - Linux Machine is assigned a cloud-init file configuraiton for first time setup (/cloudinit/custom.yml)

### *outputs.tf* File
- Provides necessary ip information that is allocated to the VMs created.
- This information by default includes:
    - Private IPs for all 5 deployed VMs (Which we know will by based on variables.tf file data)
    - Public IP for Linux machine (Not known by default, will be used for SSH connection if needed).

## Useful Azure related functions
Finding variable information for VM Images variables:
- You can use this command in Azure CLI to find UbuntuServer data. Change the values in offer, publisher, location, and sku for various other images.
 ````Powershell
    az vm image list \
    --location westus \
    --publisher Canonical \  
    --offer UbuntuServer \    
    --sku 18.04-LTS \
    --all --output table
````
-  "Check out Microsoft's" [documentation](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/cli-ps-findimage) on finding VM information


# Ansible
Main role: Configure the deployed Virtual Machines.
-   Setup Windows Server Feature: Domain
    - Primary Domain Controller 
    - Replica Domain Controller
    - Auto-Join the Virutal Machines to the respective Domain created
    - Create a few users and groups within Active Directory
-   Setup Windows Ssrver Feature: DHCP 
    - Setup DHCP Scope
    - Authorize it to the Domain.
-   Setup Windows Server Feature: File Sharing
    - Create two shares
        - An employee share and administrator share. These shares are assigned group permissions.
-   Common Configurations
    - Enable RDP and allow it through the firewall on all windows servers created at server level
## Ansible Variable files 
- *inventory.yml*
    - Modify hosts associated with the playbook. Assign the IP addressing
        - **MUST MATCH _terraform.tfvars_ VARIABLE IP ADDRESSING**
- *winlab.yml*
    - Associate 'roles' to the hosts identified in the inventory file. 
    - These 'roles' are folders within the directory containing a set of code to configure per host
- *ansible.cfg*
    - Tells ansible variable information. In this scenario, identifies to use inventory.yml file.
- *./group_vars/all.yml*
    - Contains specific variable information used within the ./roles/* Ansible code.
    - Alter user, password, port, connection, and cert variable information
    - Alter domain variables as well

## Running Ansible
This is taken care of with terraform cloud-init file along with the file provisioner. The alternative would be below.
- On Linux Machine,
    - Requires: Python-pip, ansible-galaxzy-azure.azure_preview_modules
    - To Run: Navigate to Ansible directory and type `ansible-playbook winlab.yml`

# Useful Resources 
## Terraform Resources
- Terraform [Documentation](https://www.terraform.io/docs)
- Azure [Provider](https://registry.terraform.io/providers/hashicorp/azurerm/2.96.0) & [Modules](https://registry.terraform.io/modules/Azure/compute/azurerm/latest)
- Cloud-init [Documentation](https://cloudinit.readthedocs.io/en/latest/)
- [terraform-provider-azurerm](https://github.com/hashicorp/terraform-provider-azurerm) examples and documentation on GitHub
## Ansible Resources
- Ansible [Documentation](https://docs.ansible.com/)
  - [Windows-Modules](https://galaxy.ansible.com/ansible/windows?extIdCarryOver=true&sc_cid=701f2000001OH7YAAW)


