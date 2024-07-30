variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}

variable "secgrps" {
    type = map(object({
      description = optional(string)
      ingress = list(object({
        from_port = number
        to_port = number
        protocol = string
        cidr_blocks = list(string)
        security_groups = list(string)
        description = string
      }))
      egress = list(object({
        from_port = number
        to_port = number
        protocol = string
        cidr_blocks = list(string)
        security_groups = list(string)
        description = string
      }))
    }))
}