

## Set up SSH user
SSH user set within cloudinit, and is based on SSH key. You will need to generate a key with ssh-keygen, and put the resulting key into the cloudinit file.

ssh in as user vpn@IP_ADDRESS

## Getting the OpenVPN client.ovpn file
- SSH into the machine, allow authentication
    - To ssh `ssh vpn@PUBLICIPHERE`
    - `scp -p vpn@PUBLIC4IPHERE:client.ovpn client.ovpn`
- On Windows, download OPENVPN software.
    - Upload client.ovpn file into it