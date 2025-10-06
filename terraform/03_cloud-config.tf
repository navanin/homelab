resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pve_default_node

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: ubuntu-vm
    timezone: ${var.cloud_init_timezone}
    growpart:
      mode: auto
      devices: ["/"]
    resize_rootfs: true
    users:
      - default
      - name: ${var.cloud_init_username}
        groups: [sudo]
        shell: /bin/bash
        ssh_authorized_keys:
          - ${var.cloud_init_ssh_key}
        lock_passwd: false
        passwd: ${var.cloud_init_passwd_hash}
    package_update: true
    package_upgrade: true
    packages:
      - qemu-guest-agent
      - net-tools
      - btop
      - ca-certificates
      - curl
      - gnupg
      - apt-transport-https
    write_files:
      - path: /etc/ssh/sshd_config.d/99-hardening.conf
        permissions: "0644"
        content: |
          # Cloud Init Managed
          PasswordAuthentication no
          ChallengeResponseAuthentication no
          UsePAM yes
          PermitRootLogin prohibit-password
    runcmd:
      # Docker
      - curl -fsSL https://get.docker.com | bash
      # Enabling services
      - systemctl daemon-reload
      - systemctl enable --now qemu-guest-agent
      - systemctl enable --now docker

      # Apply SSH Config
      - systemctl reload ssh || systemctl restart ssh
      - echo "done" > /tmp/cloud-config.done

    final_message: "cloud-init successfully done."
    EOF

    file_name = "tf_user-data_cloud_config.yaml"
  }
}