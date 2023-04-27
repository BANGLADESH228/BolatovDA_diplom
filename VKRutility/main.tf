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
  token     = "#"
  cloud_id  = "#"
  folder_id = "#"
  zone      = "#"
}

# ------------------------------------------------------------------------------
# Virtual Machine Configuration 1
# ------------------------------------------------------------------------------

resource "yandex_compute_instance" "vm-1" {
  name        = "linux-vm-1"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"

  resources {
    cores  = "2"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      image_id = "fd8o41nbel1uqngk0op2"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt-get update"
  #   ]

  #   connection {
  #     type     = "ssh"
  #     user     = "debian"
  #     private_key = file("~/.ssh/id_rsa")
  #     host     = yandex_compute_instance.vm-1.network_interface.0.ip_address
  #   }
  # }

  metadata = {
    ssh-keys  = "DBA:${file("~/.ssh/id_rsa.pub")}"
    user_data = "${file("/scripts/user-data")}"
  }
}

# ------------------------------------------------------------------------------
# Virtual Machine Configuration 2
# ------------------------------------------------------------------------------

resource "yandex_compute_instance" "vm-2" {
  name        = "linux-vm-2"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"

  resources {
    cores  = "2"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      image_id = "fd82sqrj4uk9j7vlki3q"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user_data = "${file("/scripts/user-data")}"
  }
}

# ------------------------------------------------------------------------------
# Network Configuration
# ------------------------------------------------------------------------------

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["192.168.10.0/24"]
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