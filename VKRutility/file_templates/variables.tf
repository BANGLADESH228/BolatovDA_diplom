# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# VKR - variables.tf
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

variable "token" {
  type        = string
  description = "Yandex Cloud Service Account Token"
  default     = "#"
}

variable "cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
  default     = "#"
}

variable "folder_id" {
  type        = string
  description = "Yandex Cloud Folder ID"
  default     = "#"
}

variable "zone" {
  type        = string
  description = "Default Zone for Yandex Cloud Compute Resources"
  default     = "#"
}

# ------------------------------------------------------------------------------
# Virtual Machine Configuration 1
# ------------------------------------------------------------------------------

variable "vm1_image_id" {
  type        = string
  description = "Image ID for Virtual Machine 1"
  default     = "fd8o41nbel1uqngk0op2"
}

variable "vm1_name" {
  type        = string
  description = "Name of Virtual Machine 1"
  default     = "linux-vm-1"
}

variable "vm1_platform_id" {
  type        = string
  description = "Platform ID for Virtual Machine 1"
  default     = "standard-v3"
}

variable "vm1_cores" {
  type        = string
  description = "Number of cores for Virtual Machine 1"
  default     = "2"
}

variable "vm1_memory" {
  type        = string
  description = "Memory in GB for Virtual Machine 1"
  default     = "2"
}

# ------------------------------------------------------------------------------
# Virtual Machine Configuration 2
# ------------------------------------------------------------------------------

variable "vm2_image_id" {
  type        = string
  description = "Image ID for Virtual Machine 2"
  default     = "fd82sqrj4uk9j7vlki3q"
}

variable "vm2_name" {
  type        = string
  description = "Name of Virtual Machine 2"
  default     = "linux-vm-2"
}

variable "vm2_platform_id" {
  type        = string
  description = "Platform ID for Virtual Machine 2"
  default     = "standard-v3"
}

variable "vm2_cores" {
  type        = string
  description = "Number of cores for Virtual Machine 2"
  default     = "2"
}

variable "vm2_memory" {
  type        = string
  description = "Memory in GB for Virtual Machine 2"
  default     = "2"
}

# ------------------------------------------------------------------------------
# Network Configuration
# ------------------------------------------------------------------------------

variable "network_name" {
  type        = string
  description = "Name of the Yandex Cloud Virtual Network"
  default     = "network1"
}

variable "subnet_name" {
  type        = string
  description = "Name of the Yandex Cloud Subnet"
  default     = "subnet1"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR Block for the Yandex Cloud Subnet"
  default     = "192.168.10.0/24"
}

