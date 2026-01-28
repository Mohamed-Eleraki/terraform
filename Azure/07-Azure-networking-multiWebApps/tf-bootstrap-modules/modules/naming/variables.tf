variable "environment" {
  description = "The environment for the resources (e.g., hub1, hub2, spk1, spk2)."
  type        = string
  validation {
   condition = contains(["hub1", "hub2", "spk1", "spk2"], var.environment) 
   error_message = "value must be one of 'hub1', 'hub2', 'spk1', or 'spk2'."
  }
}

variable "sysrole" {
  description = "The system role for the resources (e.g., mgmt, shared, netspoke)."
  type        = string
  validation {
   condition = contains(["mgmt", "shared", "netspoke"], var.sysrole)
   error_message = "value must be one of 'mgmt', 'shared', 'landing', or 'workloads'."
  }
}