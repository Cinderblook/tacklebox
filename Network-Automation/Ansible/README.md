# Setup Ansible
`sudo apt update`
`sudo apt install ansible`
`sudo apt install sshpass -y`

## Example Usage
To ping devices
`ansible -i ./hosts/hosts.yaml ubuntu -m ping -u SSHUSERNAME --ask-pass`

To pass playbooks
`ansible-playbook ./playbooks/apt.yaml --user SSHUSERNAME --ask-pass --ask-become-pass -i ./hosts/hosts.yaml`

Useful specific commands
-i "Followed by inventory file"
-u "Username for SSH"
--ask-pass OR -k "Specifies to ask for a password for SSH"
--ask-become-pass "Enables sudo"

-e "Extra variable, etc: Network OS"
