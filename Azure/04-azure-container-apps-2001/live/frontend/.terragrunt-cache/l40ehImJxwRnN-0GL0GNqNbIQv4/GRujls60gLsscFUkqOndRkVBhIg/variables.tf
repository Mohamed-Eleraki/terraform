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
variable "capps_application_name" {
  description = "application app name"
  type        = string
}
variable "resource_group_name" {
  description = "resouce group name"
  type        = string
}
variable "container_app_environment_id" {
  description = "container app environment id"
}
variable "container-name" {
  description = "container name"
  type        = string
}
variable "container-image" {
  description = "container images"
}
variable "container-cpu" {
  description = "container cpu"
}
variable "container-memory" {
  description = "container memory"
}
variable "container-env-vars" {
  type = map(list(object({
    name  = string
    value = string
  })))
  description = "Map of environment variables per container (by container key)"
  default     = {}
}
variable "container-external-enable" {
  description = "container-external-enable"
  type        = bool
}
variable "container-target-port" {
  description = "container target port"
  type        = number
}
variable "container-transport" {
  description = "container transport"
  type        = string
}
variable "container-latest-revision" {
  description = "container traffic weight latest revision"
  type        = bool
}
variable "container-precentage" {
  description = "container traffic weight precentage"
  type        = number
}
# variable "containerapps" {
#   type = map(object({
#     name = string
#     template = list(object({
#       name   = string
#       image  = string
#       cpu    = number
#       memory = string
#       env = optional(list(object({
#         name  = string
#         value = string
#       })))
#     }))
#     ingress = object({
#       external_enabled = bool
#       target_port      = number
#       transport        = string
#       traffic_weight = list(object({
#         latest_revision = bool
#         percentage      = number
#       }))
#     })
#   }))
# }
