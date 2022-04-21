# Overview
Use packer to develop a prepared Linux Template in Proxmox. In this case, it will be a Ubuntu Server 20.04.4 image.

# Packer Process
cd into the project directory (./ubuntu-server-focal), and run `packer validate -var-file='..\credentials.pkr.hcl' .\ubuntu-server-focal.pkr.hcl`

-  If any errors show up, you'll have to fix them before moving on

Now, to actually build the image, run `packer build -var-file='..\credentials.pkr.hcl' .\ubuntu-server-focal.pkr.hcl`