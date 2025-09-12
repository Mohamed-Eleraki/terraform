variable "region" {
  description = "region in which resources will be created"
  type        = string
}
variable "development_environment_short" {
  description = "an environment name short"
  type        = string
}
variable "region_short" {
  description = "region short name"
  type        = string
}
variable "resource_group_name" {
  description = "resouce group name"
  type        = string
}
variable "log_analytics_id" {
  description = "log analytics workspace id"
  type        = string
}
