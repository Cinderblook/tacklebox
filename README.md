![tacklebox](https://socialify.git.ci/Cinderblook/tacklebox/image?description=1&font=KoHo&owner=1&pattern=Circuit%20Board&theme=Dark) 

# Categories
Distinct layout of what is throughout this repository. Some notable projects are shown for each category.
## [**Packer**](https://github.com/Cinderblook/tacklebox/tree/main/Packer) <img src="https://www.packer.io/favicon.ico" alt="Packer" width="40"> <br>

* [proxmox-iso-ubuntu](https://github.com/Cinderblook/tacklebox/tree/main/Packer/Proxmox/packer-iso-ubuntu); Using Packer to create a configured Ubuntu tempalte within Proxmox environment

* [packer-iso-winserv](https://github.com/Cinderblook/tacklebox/tree/main/Packer/vSphere/packer-iso-winserv); Using Packer to create a configured Windows Server tempalte within vSphere environment

## [**Terraform**](https://github.com/Cinderblook/tacklebox/tree/main/Terraform) <img src="https://www.terraform.io/favicon.ico" alt="Terraform" width="40"> <br>

*Azure:*

* [Azure-Serv-Deploy](https://github.com/Cinderblook/tacklebox/tree/main/Terraform/Azure/Azure-Serv-Deploy); Creating multiple windows servers in Azure enrolled in a domain. This has functioning/active DHCP, DNS, and Active Directory. The environment has security groups, users, and memberships applied.

* [Azure-K8S-Deploy](https://github.com/Cinderblook/tacklebox/tree/main/Terraform/Azure/Azure-K8S-Deploy); Creating a Kubernetes cluster with AKS in Azure.

* [Azure-VPN-Setup](https://github.com/Cinderblook/tacklebox/tree/main/Terraform/Azure/Azure-VPN-Setup); Automating VPN VMs out in Azure with OpenVPN.

*Spotify:*

* [shuffle-playlist](https://github.com/Cinderblook/tacklebox/tree/main/Terraform/Spotify/shuffle-playlist)/[dynamic-playlist](https://github.com/Cinderblook/tacklebox/tree/main/Terraform/Spotify/dynamic-playlist)/[multi-artist-playlist](https://github.com/Cinderblook/tacklebox/tree/main/Terraform/Spotify/multi-artist-playlist); Automating the Creation of a custom spotify playlist using Spotify Developer tools.

*vSphere:*
* [vSphere-WinServ-Deployment](https://github.com/Cinderblook/tacklebox/tree/main/Terraform/vSphere/vSphere-WinServ-Deployment); Within a local vSphere center, create multiple windows servers enrolled in a domain. This has functioning/active DHCP, DNS, and Active Directory. The environment has security groups, users, and memberships applied. 

*Proxmox:*
* [deploy-vm](https://github.com/Cinderblook/tacklebox/tree/main/Terraform/Proxmox/deploy-vm) & [deploy-multi-vm](https://github.com/Cinderblook/tacklebox/tree/main/Terraform/Proxmox/deploy-multi-vm): Creating Virtual Machines in Proxmox from a template
## [**Network-Automation**](https://github.com/Cinderblook/tacklebox/tree/main/Network-Automation) <img src="https://www.python.org/static/favicon.ico" alt="Network" width="40"> <img src="https://www.ansible.com/hs-fs/hub/330046/file-448313641.png" alt="Packer" width="40"> <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/PowerShell_Core_6.0_icon.png/64px-PowerShell_Core_6.0_icon.png" alt="Network" width="40"> <br>
* Powershell, Ansible, Python
    - In the process of migrating various scripts I have into this. Gradually updating.

## [**Kubernetes**](https://github.com/Cinderblook/tacklebox/tree/main/Kubernetes) <img src="https://kubernetes.io/images/favicon.png" alt="Kubernetes" width="40"> 
* [k3s-HACluster-Rancher](https://github.com/Cinderblook/tacklebox/tree/main/Kubernetes/k3s-HACluster-Rancher); Create a highly available K3S Cluster managed with Rancher.

## [**Docker**](https://github.com/Cinderblook/tacklebox/tree/main/Docker) <img src="https://www.docker.com/favicon.ico" alt="Docker" width="40">
* Some homelab Docker-Compose services I've dabbled with and ran