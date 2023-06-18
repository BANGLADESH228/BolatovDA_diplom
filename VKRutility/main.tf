# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# VKR
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

# ------------------------------------------------------------------------------
# Virtual Machine Configuration 1
# ------------------------------------------------------------------------------

resource "yandex_compute_instance" "vm-1" {
  name          = var.vm1_name
  platform_id   = var.vm1_platform_id
  zone          = var.zone

  resources {
    cores  = var.vm1_cores
    memory = var.vm1_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.vm1_image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "debian:${file("~/.ssh/id_rsa.pub")}"
  }
}

# ------------------------------------------------------------------------------
# Virtual Machine Configuration 2
# ------------------------------------------------------------------------------

resource "yandex_compute_instance" "vm-2" {
  name          = var.vm2_name
  platform_id   = var.vm2_platform_id
  zone          = var.zone

  resources {
    cores  = var.vm2_cores
    memory = var.vm2_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.vm2_image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# ------------------------------------------------------------------------------
# Network Configuration
# ------------------------------------------------------------------------------

resource "yandex_vpc_network" "network-1" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = var.subnet_name
  zone           = var.zone
  v4_cidr_blocks = [var.subnet_cidr]
  network_id     = yandex_vpc_network.network-1.id
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}

# ------------------------------------------------------------------------------
# Setup VM after Terraform
# ------------------------------------------------------------------------------

resource "null_resource" "install_script" {
  provisioner "local-exec" {
    command = <<-EOT
      scp -i ~/.ssh/id_rsa setup_vm_after_terraform debian@${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}:~/setup_vm_after_terraform
      ssh -i ~/.ssh/id_rsa debian@${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address} 'chmod +x ~/setup_vm_after_terraform && ~/setup_vm_after_terraform'
    EOT
  }
}
