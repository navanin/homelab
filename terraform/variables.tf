# Provider Variables
variable "virtual_environment_endpoint" {
  type        = string
  description = "The endpoint for the Proxmox Virtual Environment API (example: https://host:port)"
}

variable "virtual_environment_api_token" {
  type        = string
  description = "The token for the Proxmox Virtual Environment API"
  sensitive   = true
}

variable "virtual_environment_ssh_username" {
  type        = string
  description = "The SSH username for the Proxmox Virtual Environment"
  sensitive   = true
}

variable "virtual_environment_ssh_password" {
  type        = string
  description = "The SSH password for the Proxmox Virtual Environment"
  sensitive   = true
}

# Network variables
variable "network_dns_domain" {
  type        = string
  description = "DNS lookup domain"
}

variable "network_ip4" {
  type        = string
  description = "IPv4 network base address"
}

variable "network_ip4_mask" {
  type        = string
  description = "IPv4 network subnet mask"
}

variable "network_ip4_gateway_addr" {
  type        = string
  description = "IPv4 network gateway address"
}

variable "network_ip4_dns_addr" {
  type        = string
  description = "IPv4 network dns address"
}


# PVE variables
variable "pve_default_node" {
  type = string
  description = "Default PVE node name"
}

# Cloud Init variables
variable "cloud_init_timezone" {
  type = string
  description = "Default VMs timezone"
}

variable "cloud_init_username" {
  type        = string
  description = "Cloud-Init user username"
  sensitive   = true
}

variable "cloud_init_passwd_hash" {
  type        = string
  description = "Cloud-Init user password"
  sensitive   = true
}

variable "cloud_init_ssh_key" {
  type        = string
  description = "Cloud-Init user SSH public key"
  sensitive   = true
}

# USB Devices variables
variable "zigbee_dongle" {
  type        = string
  description = "Zigbee Dongle USB address"
}
variable "bluetooth" {
  type        = string
  description = "Bluetooth USB address"
}
