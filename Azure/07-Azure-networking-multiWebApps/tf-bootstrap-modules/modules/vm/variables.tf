variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to create the VM in"
  type        = string
}

variable "region" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where NIC will be attached"
  type        = string
}

variable "network_interface_id" {
  description = "If set, use an existing network interface (provide its id). Leave empty to create one."
  type        = string
  default     = ""
}

variable "create_public_ip" {
  description = "Whether to create a public IP for the VM's NIC when a new NIC is created"
  type        = bool
  default     = true
}

variable "vm_size" {
  description = "VM size (default: small burstable instance for simple workloads)"
  type        = string
  default     = "Standard_B1s"
}

variable "os_disk_size_gb" {
  description = "OS disk size (GB)"
  type        = number
  default     = 30
}

variable "os_disk_type" {
  description = "Managed disk type for the OS disk"
  type        = string
  default     = "Standard_LRS"
}

variable "image_publisher" {
  description = "Image publisher"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Image offer"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "Image SKU"
  type        = string
  default     = "22_04-lts-gen2"
}

variable "image_version" {
  description = "Image version"
  type        = string
  default     = "latest"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "ubuntu"
}

# variable "admin_ssh_key" {
#   description = "OpenSSH public key string for admin user (authorized_keys content). This variable is required."
#   type        = string
#   sensitive   = true
#   validation {
#     condition     = length(var.admin_ssh_key) > 0
#     error_message = "admin_ssh_key must be provided and contain your OpenSSH public key string."
#   }
# }

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
  default     = "ubuntu@12345"
}
