terraform {
  required_providers {
    proxmox = {
      # https://github.com/bpg/terraform-provider-proxmox
      source  = "bpg/proxmox"
      version = ">= 0.84.1"
    }
  }
}

# Provider parameters
provider "proxmox" {
  endpoint  = var.virtual_environment_endpoint
  api_token = var.virtual_environment_api_token
  insecure  = false # needs ssl

  # SSH is used by provider in some cases, so we should define a username and password for ssh
  ssh {
    agent    = true
    username = var.virtual_environment_ssh_username
    password = var.virtual_environment_ssh_password
  }
}
