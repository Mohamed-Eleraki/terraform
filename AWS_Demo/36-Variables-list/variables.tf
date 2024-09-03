variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_list" {
  description = "public subnet list"
  type        = list(string)
  default = [ 
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24"
    ]
}

variable "private_subnet_list" {
  description = "private subnet list"
  type = list(string)
  default = [     
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24",
    "10.0.105.0/24",
    "10.0.106.0/24",
    "10.0.107.0/24",
    "10.0.108.0/24"
    ]
}

variable "public_subnet_count" {
  description = "count of public subnets"
  type = number
  default = 2
}

variable "private_subnet_count" {
  description = "count of private subnets"
  type = number
  default = 2
}

variable "resource_tags" {
  description = "resource tag map"
  type = map(string)
  default = {
    environment =  "dev",
    owner = "erakierakierakierakieraki"
  }

  validation {
    condition = length(var.resource_tags["environment"]) <= 16 && length(regexall("[^a-zA-z0-9-]", var.resource_tags["environment"])) == 0
    error_message = "The project tag must be no more than 16 characters, and only contain letters, numbers, and hyphens."
  }

  validation {
    condition = length(var.resource_tags["owner"]) <= 8 && length(regexall("[^a-zA-z0-9-]", var.resource_tags["owner"])) == 0
    error_message = "The project tag must be no more than 8 characters, and only contain letters, numbers, and hyphens."
  }
}
# terraform console
# > var.resource_tags["environment"]
# "dev"