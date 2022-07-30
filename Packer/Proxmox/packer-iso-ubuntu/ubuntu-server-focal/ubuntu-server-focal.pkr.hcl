variable "pm_api_url" {
    type = string
}

variable "pm_api_token_id" {
    type = string
}

variable "pm_api_token_secret" {
    type = string
    sensitive = true
}

variable "pm_node" {
    type = string
}

variable "pm_storage_pool" {
    type = string
}

variable "pm_storage_pool_type" {
    type = string
}

variable "ssh_username" {
    type = string
}

variable "ssh_password" {
    type = string
    sensitive = true
}

variable "ssh_private_key_file" {
    type = string
}

variable "vm_name" {
    type = string
}

variable "vm_id" {
    type = string
}

variable "iso_file" {
    type = string
}

source "proxmox" "ubuntu-server" {
    # Proxmox connection settings
    proxmox_url = "${var.pm_api_url}"
    username = "${var.pm_api_token_id}"
    token = "${var.pm_api_token_secret}"
    # Uncomment if you don't have a trusted certificate on the server
    insecure_skip_tls_verify = true

    # VM settings
    node = "${var.pm_node}"
    vm_id = "${var.vm_id}"
    vm_name = "${var.vm_name}"
    template_description = "Built on Packer"

    # VM OS settings
    iso_file = "${var.iso_file}"
    #   You can also download an ISO
    #iso_url = "https://releases.ubuntu.com/20.04/ubuntu-20.04.4-live-server-amd64.iso"
    #iso_checksum = "28ccdb56450e643bad03bb7bcf7507ce3d8d90e8bf09e38f6bd9ac298a98eaad"
    iso_storage_pool = "local"
    unmount_iso = true

    qemu_agent = true
    scsi_controller = "virtio-scsi-pci"

    cores = "2"
    memory = "2048"
    disks {
        disk_size = "32G"
        format = "raw"
        storage_pool = "${var.pm_storage_pool}"
        storage_pool_type = "${var.pm_storage_pool_type}"
        type = "sata"
    }
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
        #vlan_tag = "1"
    }

    # Configure Cloud-Init settings
    cloud_init = true
    cloud_init_storage_pool = "${var.pm_storage_pool}"

    # Configure Packer boot commands
    boot_command = [
    "e<down><down><down><end>",
    "autoinstall net.ifnames=0 biosdevname=0 ip=dhcp ipv6.disable=1 ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
    "<F10>",
    ]
    boot = "c"
    boot_wait = "5s"

    # Configure Packer autoinstall settings
    http_directory = "http"
    http_bind_address = "0.0.0.0"
    http_port_min = 8802
    http_port_max = 8802

    # SSH connection settings
    ssh_username = "${var.ssh_username}"
    #     Use password
    ssh_password = "${var.ssh_password}"
    #     Use private key file
    #ssh_private_key_file = "${var.ssh_private_key_file}"
    ssh_timeout = "20m"
}

build {
    name = "ubuntu-server"
    sources = ["source.proxmox.ubuntu-server"]

    # Provision the VM template for Cloud-Init integration step 3
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo sync"
        ]
    }

    # Provision the VM template for Cloud-Init integration step 2
    provisioner "file" {
        source = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    # Provision the VM template for Cloud-Init integration step 3
    provisioner "shell" {
        inline = ["sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg"]

    }
}