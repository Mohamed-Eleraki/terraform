variable "region" {
  description = "region in which resources will be created"
  type        = string
}
variable "development_environment_short" {
  description = "an environment name short"
  type        = string
}
variable "container_registry_short" {
  description = "a shortcut of container registry"
  type        = string
}
variable "region_shot" {
  description = "region short name"
  type        = string
}
variable "capps_application_name" {
  description = "application app name"
  type        = string
}

variable "containerapps" {
  type = map(object({
    name = string
    template = list(object({
      name   = string
      image  = string
      cpu    = number
      memory = string
      env = optional(list(object({
        name  = string
        value = string
      })))
    }))
    ingress = object({
      external_enabled = bool
      target_port      = number
      transport        = string
      traffic_weight = list(object({
        latest_revision = bool
        percentage      = number
      }))
    })
  }))
}
