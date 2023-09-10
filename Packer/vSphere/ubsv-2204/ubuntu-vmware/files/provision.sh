#!/bin/bash
username=$1

echo "username is $username"

touch /home/$username/done-packer
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
DEBIAN_FRONTEND=noninteractive apt-get -y autoremove

chmod 600 ~/.ssh/authorized_keys

DEBIAN_FRONTEND=noninteractive apt-get purge -y cloud-init
rm -rf /etc/cloud
rm -rf /run/cloud-init/
DEBIAN_FRONTEND=noninteractive apt-get -y install cloud-init
rm -f /etc/cloud/cloud.cfg.d/90_dpkg.cfg

rm /etc/netplan/*
echo 'network:' | tee /etc/netplan/99-dhcp.yaml
echo '  version: 2' | tee -a /etc/netplan/99-dhcp.yaml
echo '  renderer: networkd' | tee -a /etc/netplan/99-dhcp.yaml
echo '  ethernets:' | tee -a /etc/netplan/99-dhcp.yaml
echo '    ens192:' | tee -a /etc/netplan/99-dhcp.yaml
echo '      dhcp4: true' | tee -a /etc/netplan/99-dhcp.yaml

sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT.*/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/' /etc/default/grub
update-grub

passwd -e $username
usermod -aG sudo $username
rm /etc/sudoers.d/$username

