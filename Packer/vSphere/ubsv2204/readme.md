

Install whois for mkpassword creation

```bash
apt-get install whois
mkpasswd -m sha-512 --rounds=4096
```


Run 

`packer build -force -on-error=ask -var-file variables.pkrvars100GBdisk.hcl -var-file vsphere.pkrvars.hcl ubuntu-22.04.pkr.hcl`

