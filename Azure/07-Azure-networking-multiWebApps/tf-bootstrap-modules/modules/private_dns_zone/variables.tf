variable "private_dns_zone_name" {
  description = "Name of the Private DNS Zone"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resource group where Private DNS Zone will be created"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Private DNS Zone"
  type        = map(string)
  default     = {}
}
variable "webapp_private_ip" {
  description = "Private IP address of the web application to create an A record for"
  type        = string
}
variable "virtual_network_id" {
  description = "value of the Virtual Network ID to link with the Private DNS Zone"
  type        = string
}