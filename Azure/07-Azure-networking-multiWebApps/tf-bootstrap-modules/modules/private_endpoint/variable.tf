variable "private_endpoint_name" {
  description = "Name of the Private Endpoint"
  type        = string
}
variable "region" {
  description = "Azure location/region for the resources"
  type        = string
}
variable "resource_group_name" {
  description = "Name of the existing resource group where Private Endpoint will be created"
  type        = string
}
variable "subnet_id" {
  description = "ID of the subnet where the Private Endpoint will be placed"  
  type        = string
}
variable "private_connection_resource_id" {
  description = "The resource ID of the resource to which the Private Endpoint will connect"
  type        = string
}
variable "subresource_names" {}
variable "tags" {}