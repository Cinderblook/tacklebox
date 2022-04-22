# Windows Server 2022

## Ultimate Goal w/ Packer in this Project

Create a Windows Server 2022 .iso that is updated and has VMTools installed by default using [Packer](https://www.packer.io/). In this solution, it will be geared to usage with vSphere, a VMware product.

## Prerequisites

* [Packer](https://www.packer.io/downloads) to create and maintain the .iso
* A working [VMware vCenter](https://www.vmware.com/products/vcenter-server.html) and [VMware ESXI](https://www.vmware.com/products/esxi-and-esx.html) environment that will hosts the Packer file, and be used for creation of VMs on.

## The Packer Process

**First: Packer uses `autounattend.xml` and `sysprep-autounattend.xml` to automate Windows Settings**
  * It pulls Windows Server 2022 Datacenter Eval Edition (Desktop Experience) from Microsoft's site
  * Installs & configure OpenSSH Client & Server for remote connection
  * Installs VMware tools from ISO provided from the build ESX server

**Packer Provisioner Steps**
* Updating OS via Windows Update
* Doing some OS adjustments
  * Set Windows telemetry settings to minimum
  * Show file extentions by default
  * Install [Chocolatey](https://chocolatey.org/) - a Windows package manager
    * Install Microsoft Edge (Chromium)
    * Install Win32-OpenSSH-Server
    * Install PowerShell Core
    * Install 7-Zip
    * Install Notepad++
  * Enable Powershell-Core (`pwsh`) to be the default SSHD shell
* Cleanup tasks
* Remove CDROM drives from VM template (otherwise there would be 2)

## HowTo

### Requirements

* vSphere environment setup in conjuction with ESXI
* Host with Packer setup contianing necessary connection and files (`packer init` to setup environment)

### Configure Build Variables

Plenty of variables can be changed before building at the top of the `WinServ2022.pkr.hcl` file.
You can overwrite these variables in the file, in a variable file or via commandline.

See the [Packer documentation on user variables](https://www.packer.io/docs/templates/hcl_templates/variables) for details.

A lot of these variables are required for the build but do not have default values. 
In this case packer will search for environment variables starting with `PKR_VAR_`, e.g. `PKR_VAR_vcenter_server`. 
You can either set these environment variables in your build environment or overwrite the defaults like described above.

| Packer Variable      | Default Value | Description                                                                                                                                                    |
| -------------------- | ------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `iso_url`            | `https://...` | Link to the WinServ2022 installation ISO file (see `WinServ2022.pkr.hcl`)                                                                                                   |
| `iso_checksum`       | `sha256:....` | SHA256 checksum of above ISO file (see `WinServ2022.pkr.hcl`)                                                                                                          |
| `vcenter_server`     | NONE          | VMware vSphere vCenter to connect to for building with the `vsphere-iso` builder                                                                               |
| `vcenter_user`       | NONE          | The user to connect with to the vCenter                                                                                                                        |
| `vcenter_password`   | NONE          | Above user's password                                                                                                                                          |
| `vcenter_datacenter` | NONE          | The name of the vSphere datacenter to build in                                                                                                                 |
| `esx_host`           | NONE          | The ESX to build on                                                                                                                                            |
| `esx_user`           | NONE          | User to connect to above ESX                                                                                                                                   |
| `esx_password`       | NONE          | Above user's password                                                                                                                                          |


### How to use Packer

To create a Windows Server VM image using a vSphere ESX host:
<br>
First, ensure you have proper network connection and authorization with the vSphere server from your host. Then, type the following code in: <br>
```sh
cd <path-to-packer-directory>
packer init
packer build WinServ2022.pkr.hcl
```

Wait for the build to finish, you will find .iso in the datastore specified. This may take awhile.

## Default credentials

The default credentials for this VM image are:

| Username      | Password    |
| ------------- | ----------- |
| Administrator | `Password1234`|

## Resources

- [Packerws2022](https://github.com/dteslya/win-iac-lab/tree/master/packer) (Used as a base for this packer setup - Phenominal work)
- [Hashicorp Windows Update Script](https://github.com/hashicorp/best-practices/blob/master/packer/scripts/windows/install_windows_updates.ps1) Resource for script to update Windows
- I pulled a lot of information from the Official Packer repository, StackOverflow, various Github repositories... the community surrounding this is amazing.