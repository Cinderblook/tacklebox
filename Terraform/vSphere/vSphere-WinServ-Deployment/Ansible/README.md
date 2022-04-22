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

## Useful Ansible Resources
- Ansible [Documentation](https://docs.ansible.com/)
  - [Windows-Modules](https://galaxy.ansible.com/ansible/windows?extIdCarryOver=true&sc_cid=701f2000001OH7YAAW)