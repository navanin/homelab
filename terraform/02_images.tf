# Ubuntu 24.04 QEMU Cloud Image
resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.pve_default_node
  # We don't want to recreate image every apply, so overwrite is false
  overwrite    = false
  url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"

}
# Debian 12 Cloud Image
resource "proxmox_virtual_environment_download_file" "debian_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  file_name    = "debian-12-generic-amd64.qcow2.img"
  node_name    = var.pve_default_node
  # We don't want to recreate image every apply, so overwrite is false
  overwrite    = false
  url          = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
}