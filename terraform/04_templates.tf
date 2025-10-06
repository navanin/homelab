resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name        = "ubuntu2404-vm"
  node_name   = var.pve_default_node
  template    = true
  machine     = "q35"
  bios        = "ovmf"
  description = "Managed by Terraform"
  vm_id       = 9000

  agent {
    enabled = true
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  efi_disk {
    datastore_id = "local-lvm"
    file_format  = "raw"
    type         = "4m"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "scsi0"
    iothread     = false
    discard      = "on"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${var.network_ip4}254/${var.network_ip4_mask}"
        gateway = "${var.network_ip4}${var.network_ip4_gateway_addr}"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
  }

  # TODO: fix warning.
  lifecycle {
    ignore_changes = [ ipv4_addresses, ipv6_addresses, network_interface_names ]
  }
}

resource "proxmox_virtual_environment_vm" "debian_vm" {
  name        = "debian12-vm"
  node_name   = "pve"
  template    = true
  machine     = "q35"
  bios        = "ovmf"
  description = "Managed by Terraform"
  vm_id       = 9001

  agent {
    enabled = true
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  efi_disk {
    datastore_id = "local-lvm"
    file_format  = "raw"
    type         = "4m"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.debian_cloud_image.id
    interface    = "scsi0"
    iothread     = false
    discard      = "on"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${var.network_ip4}253/${var.network_ip4_mask}"
        gateway = "${var.network_ip4}${var.network_ip4_gateway_addr}"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }

  # Wont boot w/o this section
  # https://github.com/bpg/terraform-provider-proxmox/issues/1639
  # https://forum.proxmox.com/threads/8-3-debian-12-cloud-init-expanded-disk-ovmf-kernel-panic-on-first-boot.160125/
  serial_device {
    device = "socket"
  }

  # TODO: fix warning.
  lifecycle {
    ignore_changes = [ ipv4_addresses, ipv6_addresses, network_interface_names ]
  }

}