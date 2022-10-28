``` bash

# update /etc/apt/sources.list

deb http://ftp.us.debian.org/debian bullseye main contrib

deb http://ftp.us.debian.org/debian bullseye-updates main contrib
deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription

# security updates
deb http://security.debian.org bullseye-security main contrib
```
update 
```
apt update && apt full-upgrade
apt install proxmox-ve postfix open-iscsi
```