# USB devices mappings

# Hardcoded Sonoff Zigbee dongle mapping
# :)
resource "proxmox_virtual_environment_hardware_mapping_usb" "usb_zigbee" {
  comment = "Sonoff Zigbee 3.0 USB Dongle Plus"
  name    = "zigbee"
  map = [
    {
      comment = "Sonoff Zigbee 3.0 USB Dongle Plus"
      id      = var.zigbee_dongle
      node    = var.pve_default_node
    },
  ]
}

# Hardcoded bluethooth device mapping
# :)
resource "proxmox_virtual_environment_hardware_mapping_usb" "usb_bluetooth" {
  comment = "Integrated bluetooth adapter"
  name    = "bluetooth"
  map = [
    {
      comment = "Integrated bluetooth adapter"
      id      = var.bluetooth
      node    = var.pve_default_node
    },
  ]
}