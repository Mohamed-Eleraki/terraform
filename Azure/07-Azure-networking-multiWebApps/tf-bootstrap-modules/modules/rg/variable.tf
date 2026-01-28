variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
}
variable "region" {
  description = "The Azure region where the Resource Group will be created"
  type        = string
}
variable "tags" {
  description = "A map of tags to assign to the Resource Group"
  type        = map(string)
  default     = {}
}