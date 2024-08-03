variable "high_availability" {
  type        = bool
  description = "If this is a multiple instance deployment, choose 'true' to deploy 3 instances if not will deploy just 1"
  #default     = true
}

variable "name" {}