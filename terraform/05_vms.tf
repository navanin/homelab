locals {
  VMs = {
    homeassistant = {
      id          = 501    # 501
      template_id = proxmox_virtual_environment_vm.debian_vm.id
      cpu         = 2      # 2
      ram         = 4096   # 4096
      storage     = 32     # 32
      ip          = "51"
      description = "Home Assistant Supervised"
      devices     = [proxmox_virtual_environment_hardware_mapping_usb.usb_zigbee.name, proxmox_virtual_environment_hardware_mapping_usb.usb_bluetooth.name]
    },
    nexcloud = {
      id          = 502    # 502
      template_id = proxmox_virtual_environment_vm.ubuntu_vm.id
      cpu         = 4      # 8
      ram         = 8192  # 12288
      storage     = 500    # 500
      ip          = "52"
      description = "NextCloud VM"
      devices     = []
    },
    vaultwarden = {
      id          = 503    # 503
      template_id = proxmox_virtual_environment_vm.ubuntu_vm.id
      cpu         = 1      # 1
      ram         = 2048   # 2048
      storage     = 20     # 20
      ip          = "53"
      description = "VaultWarden"
      devices     = []
    },
    immich = {
      id          = 504    # 504
      template_id = proxmox_virtual_environment_vm.ubuntu_vm.id
      cpu         = 6      # 8
      ram         = 8192   # 8192
      storage     = 300    # 300
      ip          = "54"
      description = "Immich VM"
      devices     = []
    },
    dns = {
        id          = 506   # 506
        template_id = proxmox_virtual_environment_vm.ubuntu_vm.id
        cpu         = 1      # 2
        ram         = 4096   # 4096
        storage     = 32     # 32
        ip          = "60"
        description = "AdGuard Home DNS"
        devices     = []
    },
    proxy = {
        id          = 507   # 507
        template_id = proxmox_virtual_environment_vm.ubuntu_vm.id
        cpu         = 1      # 2
        ram         = 4096   # 4096
        storage     = 32     # 32
        ip          = "61"
        description = "Zoraxy Reverse Proxy"
        devices     = []
    },
    prod-01 = {
        id          = 509   # 509
        template_id = proxmox_virtual_environment_vm.ubuntu_vm.id
        cpu         = 2      # 2
        ram         = 2048   # 2048
        storage     = 30     # 30
        ip          = "57"
        description = "Devplatform COC Bot"
        devices     = []
    },
    k8s-master-01 = {
        id          = 1000   # 1000
        template_id = proxmox_virtual_environment_vm.ubuntu_vm.id
        cpu         = 2      # 2
        ram         = 4096   # 4096
        storage     = 60     # 60
        ip          = "200"
        description = "K8s Master"
        devices     = []
    },
    k8s-worker-01 = {
        id          = 1001   # 1001
        template_id = proxmox_virtual_environment_vm.ubuntu_vm.id
        cpu         = 4      # 2
        ram         = 6144   # 6144
        storage     = 60     # 60
        ip          = "201"
        description = "K8s Worker 1"
        devices     = []
    },
    k8s-worker-02 = {
        id          = 1002   # 1002
        template_id = proxmox_virtual_environment_vm.ubuntu_vm.id
        cpu         = 4      # 2
        ram         = 6144   # 4096
        storage     = 60     # 60
        ip          = "202"
        description = "K8s Worker 2"
        devices     = []
    },
    k8s-worker-03 = {
        id          = 1003   # 1003
        template_id = proxmox_virtual_environment_vm.ubuntu_vm.id
        cpu         = 4      # 2
        ram         = 6144   # 4096
        storage     = 60     # 60
        ip          = "203"
        description = "K8s Worker 3"
        devices     = []
    }
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  for_each    = local.VMs

  name        = each.key
  description = each.value.description
  node_name   = var.pve_default_node
  vm_id       = each.value.id

  clone {
    vm_id = each.value.template_id
  }

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cpu
  }

  memory {
    dedicated = each.value.ram
  }

  disk {
    interface    = "scsi0"
    size         = each.value.storage
    file_format  = "raw"
    discard      = "on"
  }

  network_device {
    bridge       = "vmbr0"
    disconnected = false
    enabled      = true
    firewall     = false
    model        = "virtio"
  }

  initialization {
    dns {
      servers = ["${var.network_ip4}${var.network_ip4_dns_addr}"]
      domain  = var.network_dns_domain
    }
    ip_config {
      ipv4 {
        address = "${var.network_ip4}${each.value.ip}/${var.network_ip4_mask}"
        gateway = "${var.network_ip4}${var.network_ip4_gateway_addr}"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }

  dynamic "usb" {
    for_each = toset(each.value.devices)
    content {
      mapping = usb.value
    }
  }
  lifecycle {
    ignore_changes = [initialization, clone]
  }
}
