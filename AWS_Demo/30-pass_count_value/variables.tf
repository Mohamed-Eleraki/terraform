variable "high_availability" {
  type        = number
  description = "Enter the number of instances will deployed"
  #default     = true
}

variable "name" {
  description = "Enter the value of common tags"
}

variable "accociate_public_IP" {
  type        = bool
  description = "True or False"
}