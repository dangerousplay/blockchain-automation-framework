
locals {
  VAULT_DEV_ROOT_TOKEN = "MYTOKEN"
  VAULT_EXTERNAL_PORT = 8200
}


//resource "libvirt_pool" "vault" {
//  count = terraform.workspace == "default" ? 1 : 0
//  name = "ubuntu"
//  type = "dir"
//  path = "/tmp/terraform-provider-libvirt-pool-ubuntu"
//}
//
//# We fetch the latest ubuntu release image from their mirrors
//resource "libvirt_volume" "ubuntu-qcow2" {
//  count = terraform.workspace == "default" ? 1 : 0
//  name   = "ubuntu-qcow2"
//  pool   = libvirt_pool.vault.name
//  source = "https://cloud-images.ubuntu.com/releases/xenial/release/ubuntu-16.04-server-cloudimg-amd64-disk1.img"
//  format = "qcow2"
//}
//
//data "template_file" "user_data" {
//  count = terraform.workspace == "default" ? 1 : 0
//  template = file("${path.module}/cloud_init.cfg")
//}
//
//data "template_file" "network_config" {
//  count = terraform.workspace == "default" ? 1 : 0
//  template = file("${path.module}/network_config.cfg")
//}
//
//# for more info about paramater check this out
//# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
//# Use CloudInit to add our ssh-key to the instance
//# you can add also meta_data field
//resource "libvirt_cloudinit_disk" "commoninit" {
//  count = terraform.workspace == "default" ? 1 : 0
//  name           = "commoninit.iso"
//  user_data      = data.template_file.user_data[0].rendered
//  network_config = data.template_file.network_config[0].rendered
//  pool           = libvirt_pool.vault.name
//}
//
//# Create the machine
//resource "libvirt_domain" "vault-ubuntu" {
//  count = terraform.workspace == "default" ? 1 : 0
//  name   = "ubuntu-terraform"
//  memory = "1024"
//  vcpu   = 2
//
//  cloudinit = libvirt_cloudinit_disk.commoninit[0].id
//
//  network_interface {
//    network_name = "default"
//  }
//
//  # IMPORTANT: this is a known bug on cloud images, since they expect a console
//  # we need to pass it
//  # https://bugs.launchpad.net/cloud-images/+bug/1573095
//  console {
//    type        = "pty"
//    target_port = "0"
//    target_type = "serial"
//  }
//
//  console {
//    type        = "pty"
//    target_type = "virtio"
//    target_port = "1"
//  }
//
//  disk {
//    volume_id = libvirt_volume.ubuntu-qcow2[0].id
//  }
//
//  graphics {
//    type        = "spice"
//    listen_type = "address"
//    autoport    = true
//  }
//}

//hashicorp/vault
resource "docker_container" "vault" {
  name  = "vault"
  image = "vault:1.5.4"
  env = ["VAULT_DEV_ROOT_TOKEN_ID=${local.VAULT_DEV_ROOT_TOKEN}"]

  ports {
    internal = 8200
    external = local.VAULT_EXTERNAL_PORT
  }
}

output "vault_root_token" {
  value = local.VAULT_DEV_ROOT_TOKEN
}

output "vault_host" {
  value = docker_container.vault.ip_address
}

output "vault_port" {
  value = local.VAULT_EXTERNAL_PORT
}
