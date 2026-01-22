variable "name" {
  description = "Name of the App Service (web app)"
  type        = string
}

variable "plan_name" {
  description = "Optional name of the App Service Plan. If null, defaults to <name>-plan"
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Name of the resource group where the app will be created"
  type        = string
}

variable "region" {
  description = "Azure location/region for the resources"
  type        = string
}

variable "sku_tier" {
  description = "SKU tier for the App Service Plan (e.g. Free, Shared, Basic, Standard, Premium)"
  type        = string
  default     = "Basic"
}

variable "sku_size" {
  description = "SKU size for the App Service Plan (e.g. B1, S1)"
  type        = string
  default     = "B1"
}

variable "os_type" {
  description = "Operating system for the Service Plan: Windows or Linux"
  type        = string
  default     = "Linux"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "private_endpoint_ip" {
  description = "Private IP address (or CIDR) of the private endpoint allowed to access the webapp on port 80. If null, no NSG will be created."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Optional subnet ID to associate the created NSG with. If null, NSG is created but not associated."
  type        = string
  default     = null
}
