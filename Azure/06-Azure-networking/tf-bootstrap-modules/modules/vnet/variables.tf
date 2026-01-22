variable "name" {
  description = "Name of the virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resource group where VNet will be created"
  type        = string
}

variable "region" {
  description = "Azure region to create resources in (e.g. eastus)"
  type        = string
}

variable "address_space" {
  description = "List of address space CIDRs for the virtual network (e.g. [\"10.0.0.0/16\"])"
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0
    error_message = "address_space must contain at least one CIDR block"
  }
}

variable "subnet_name" {
  description = "Name of the subnet to create inside the VNet"
  type        = string
}

variable "subnet_prefix" {
  description = "CIDR prefix for the subnet (e.g. 10.0.1.0/24)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the virtual network"
  type        = map(string)
  default     = {}
}

variable "default_outbound_access_enabled" {
  description = "Enable default outbound access for the subnet"
  type        = bool
  default     = true
  validation {
    condition     = var.default_outbound_access_enabled == true || var.default_outbound_access_enabled == false
    error_message = "default_outbound_access_enabled must be a boolean value"
  }
}