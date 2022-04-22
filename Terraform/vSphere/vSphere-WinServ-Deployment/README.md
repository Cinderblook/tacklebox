# Overview

The goal of this project is to deploy a ready-to-go windows server environment. This includes a domain controller, a replica domain controller, a DHCP server, and a fileserver. Additionally setting up users, groups, and OUs for the respective users within the domain. <br>
To complete this project, 3 steps are taken. 

1. Use Packer to spin up a sys prepped and fully updated windows server 2022 iso for the environemnt
2. Use Terraform to deploy 4 virtual machines into a vSphere environment
3. Use Ansible to configure these 4 virtual machines as desired

## 1. Packer's Role: 

Create a Windows Server 2022 .iso that is updated and has VMTools installed by default using [Packer](https://www.packer.io/). In this solution, it will be geared to usage with vSphere, a VMware product.

**First: Packer uses `autounattend.xml` and `sysprep-autounattend.xml` to automate Windows Settings**
  * It pulls Windows Server 2022 Datacenter Eval Edition (Desktop Experience) from Microsoft's site
  * Installs & configure OpenSSH Client & Server for remote connection
  * Installs VMware tools from ISO provided from the build ESX server

**Packer Provisioner Steps**
* Updating OS via Windows Update
* Doing some OS adjustments
  * Set Windows telemetry settings to minimum
  * Show file extentions by default
  * Install [Chocolatey](https://chocolatey.org/) - a Windows package manager
    * Install Microsoft Edge (Chromium)
    * Install Win32-OpenSSH-Server
    * Install PowerShell Core
    * Install 7-Zip
    * Install Notepad++
  * Enable Powershell-Core (`pwsh`) to be the default SSHD shell
* Cleanup tasks
* Remove CDROM drives from VM template (otherwise there would be 2)

## 2. Terraform's Role:
Main role: Deploy the Virtual Machines
-   Setup the four Windows Servers (Primary Domain Controller, Replica Domain Controller, DHCP, Fileshare)
    - Using the vSphere provider:
        - Assign appropriate resources to each machine 
- Once prepared with appropriate values and the networking is in place: 
    - Navigate to the Terraform directory and run these commands
    - `terraform init` Pull proper Terraform providers and modules used
    - `terraform validate` This will return whether the configuration is valid or not
    - `terraform apply` ... `yes` Actually apply the configuration
## Terraform Variable files 
- *variables.tf*
    - Declare variables that will be used with the Terraform configuration
- *terraform.tfvars*
    - Assign variables that will be used with the Terraform configuration

## 3. Ansible's Role:
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
    - Enable RDP and allow it through the firewall on all windows servers created
## Ansible Variable files 
- *inventory.yml*
    - Modify hosts associated with the playbook. Assign the IP addressing.
- *winlab.yml*
    - Associate 'roles' to the hosts identified in the inventory file. 
    - These 'roles' are folders within the directory containing a set of code to configure per host
- *ansible.cfg*
    - Tells ansible variable information. In this scenario, identifies to use inventory.yml file.
- *./group_vars/all.yml*
    - Contains specific variable information used within the ./roles/* Ansible code.

# Prerequisites
* Linux machine with the following
  * Ansible
    * `sudo apt update`
    * `sudo apt install software-properties-common`
    * `sudo add-apt-repository --yes --update ppa:ansible/ansible`
    * `sudo apt install ansible`
  * Terraform
    * `sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl`
    * `curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -`
    * `sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"`
    * `sudo apt-get update && sudo apt-get install terraform`
  * Packer
    * `curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -`
    * `sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"`
    * `sudo apt-get update && sudo apt-get install packer`
  * Git
    * `sudo apt-get install git`
* A Code Interprester
  * I recommend [Visual-Studio-Code](https://code.visualstudio.com/)
* vSphere Lab Environment
  * [vSphere](https://www.vmware.com/products/vsphere.html) --- *Note: This project is using vSphere version 7.0.0*
  <br>

# Packer
## Navigate to Packer Directory
- First setup Packer environment
    - `packer init -upgrade ws2022.pkr.hcl`
- Then apply the Packer configuration to create the Windows Server 2022 Image
    - `packer build -timestamp-ui -force -var-file=myvarfile.json ws2022.pkr.hcl`
* This packer execute pulls the newest windows server datacenter 2022 eval .iso from microsoft populates it into the vSphere environment, in the specified datacenter/cluster/host/datastore
* It then runs commands to: Grab DHCP, Updates the image, Enables SSH, Enables RDP, Configures necessary firewall settings, sets passwords/usernames, & installs VMware Tools to base image
* Additionally, it will install [Chocolatey](https://chocolatey.org/) for packages, notepad++, Edge, & 7-zip
  <br>
 ## After Packer Finishes
###### *Roughly an hour depending on processing and internet speed*
- Go into your vSphere and turn the resulting VM into a Template
  - Ensure this mimics the variables you have set in the terraform.tfvars file. This will be our next step.
# Terraform
 ## Navigate to Terraform Directory
- Setup Terraform Environemnt
  - `terraform init`
- Format terraform to ensure it meets criteria required
  - `terraform fmt`
- Do a terraform plan to detect any potential errors in code and to see potential end result. Read over this
  - `terraform plan`
- Finally, if all the above appears correct, perform a terraform apply
  - `terraform apply` ... `yes`
    - This may take awhile, once it is done, double check in vSphere all necessary Virtual Machines were created properly *(For me this took 20 minutes to fully complete)*

# Ansible
 ## Navigate to Ansible Directory
- Once you have allowed Terraform to finish its configuraiton:
  - Navigate to your Ansible Directory, `cd <path-to-Ansible>`
  - Run your ansible playbook `ansible-playbook winlab.yml`
    - This should run through and detail each change as it plays out


# References Used/Useful Links
### I sourced various code and peices of information from the following Git Repositories
- Stefan Zimmermann [GitLab](https://gitlab.com/StefanZ8n/packer-ws2022) [Article](https://z8n.eu/2021/11/09/building-a-windows-server-2022-ova-with-packer/)
- Dmitry Teslya [GitHub](https://github.com/dteslya/win-iac-lab)
### Useful places for refernece
- Tutorials for Terraform, Packer, and others [Hashicorp-Tutorials](https://learn.hashicorp.com/search?query=Packer) 
- Ansible [Documentation](https://docs.ansible.com/)
  - [Windows-Modules](https://galaxy.ansible.com/ansible/windows?extIdCarryOver=true&sc_cid=701f2000001OH7YAAW)
- Terraform [Documentation](https://www.terraform.io/docs)
- Packer [Documentation](https://www.packer.io/docs)

