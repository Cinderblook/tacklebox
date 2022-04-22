## Ansible
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
- On Linux Machine,
    - Requires: Python-pip, ansible-galaxzy-azure.azure_preview_modules
    - To Run: Navigate to Ansible directory and type `ansible-playbook winlab.yml`
    
## Useful Ansible Resources
- Ansible [Documentation](https://docs.ansible.com/)
  - [Windows-Modules](https://galaxy.ansible.com/ansible/windows?extIdCarryOver=true&sc_cid=701f2000001OH7YAAW)