#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "usage: ./build.sh <hostname> <username> <initial-password>"
    exit 1
fi

hostname=$1
username=$2
rawpassword=$3
read -s -p "vCenter Password: " vcenter_password

password=$(openssl passwd -6 $rawpassword)

# Replace hostname in subiquity file
sed -i "s/^    hostname:.*/    hostname: $hostname/" subiquity/http/user-data

# Replace username in subiquity file
sed -i "s/^    username:.*/    username: $username/" subiquity/http/user-data
sed -i "s|^    - echo '.*|    - echo '$username ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/$username|" subiquity/http/user-data

# Replace password hash in subiquity file
sed -i "s|^    password:.*|    password: $password|" subiquity/http/user-data

# Run the packer build
echo
echo packer build -var "hostname=$hostname" -var "username=$username" -var "password=$rawpassword" -var "vcenter_password=XXXXX" ./files
packer build -var "hostname=$hostname" -var "username=$username" -var "password=$rawpassword" -var "vcenter_password=$vcenter_password" ./files
