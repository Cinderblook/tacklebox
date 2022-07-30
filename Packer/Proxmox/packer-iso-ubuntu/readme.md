# Overview
Using Packer to create a Ubunut 22.04 server image within Proxmox. This is designed with Proxmox Virtual Environment version 7.1 in mind.

**Check out all of the configuration files on [GitHub](https://github.com/Cinderblook/tacklebox/tree/main/Packer/Proxmox/packer-iso-ubuntu) at the repository.**

## Prerequisites 

1. Must have [Packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli) configured on your machine, DHCP running on the network, and a Proxmox server available (Preferrable to be version 7.1)
2. Have a Proxmox user created with proper privledges for Terraform ([See how to create the user here](https://www.cinderblook.com/blog/terraform-proxmox-vm-deploy/))
3. Ubuntu Server 22.04 Iso uploaded to your Proxmox server

## Getting proper files setup
There are two primary files that will need configured. 

The first of the two is our credentials.pkr.hcl file. Update all variables within to your own. Any more in-depth configuration can be done within the ubuntu-server-focal.pkr.hcl file.

You can generate your token-id and token secret using the following command into your Proxmox Shell `pveum user token add terraform-prov@pve terraform-token --privsep=0` Replace terraform-prov@pve with your created username **Write this down because you won't be able to find this access token again later**

![Proxmox-Token-Generate](/examples/ProxmoxPacker-Example1.png "proxmoxpacker-example1")

An Example credneitals/pkr.hcl file

```tf
pm_api_url = "https://yourProxmox.server:8006/api2/json"
pm_api_token_id = "full-tokenid" 
pm_api_token_secret = "tokenValue"
pm_node = "nodeToBuildOn"
pm_storage_pool = "storagePoolToBuildOn"
pm_storage_pool_type = "typeOf-pm_storage_pool"

ssh_username = "yourSshUser"
ssh_password = "yourSshPassword"
ssh_private_key_file = "~/.ssh/id_rsa"

vm_name = "vm name"
vm_id = "1003"
iso_file = "local:iso/ubuntu-22.04-live-server-amd64.iso" #Iso file location on your proxmox
```

Second file to update to your preference is our user-data.example file. You only need to update the name field beneath user-data, users, and potentially your timezone.

An Example user-data file

```yaml
#cloud-config
autoinstall:
  version: 1
  locale: en_US
  keyboard:
    layout: en
  ssh:
    install-server: true
    allow-pw: true
    disable_root: true
    ssh_quiet_keygen: true
    allow_public_ssh_keys: true
  packages:
    - qemu-guest-agent
    - sudo
  storage:
    layout:
      name: direct
    swap:
      size: 0
  user-data:
    package_upgrade: false
    timezone: America/New_York
    users:
      - name: username-here
        groups: [adm, sudo]
        lock-passwd: false
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        # passwd: your-password
        # - or -
        # ssh_authorized_keys:
        #   - your-ssh-key
```



## Finally, the Packer Process
First thing we should do prior to going further, is double check the valiation of our Packer files. Otherwise we could have some major headache. 

1. cd into the project directory (./ubuntu-server-focal), and run `packer validate -var-file='..\credentials.pkr.hcl' .\ubuntu-server-focal.pkr.hcl`

    -  If any errors show up, you'll have to fix them before moving on

Once we have confirmed everything appears correct, we can run the build, cross our fingers, and it should work. 

2. Build the image (Within the same project directory where you ran the validate), `packer build -var-file='..\credentials.pkr.hcl' .\ubuntu-server-focal.pkr.hcl`

## Useful Resources
* [Terraform Provider for Proxmox](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs)
* [Proxmmox User Creation Guide](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs)
* [Packer Tutoritals](https://learn.hashicorp.com/packer)