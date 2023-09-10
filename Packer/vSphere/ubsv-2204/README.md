# ubuntu
Install whois for mkpassword creation

```bash
apt-get install whois
mkpasswd -m sha-512 --rounds=4096
```

Build with ```./build.sh <hostname> <username> <initial-password>```
