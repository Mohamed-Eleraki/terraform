variable "name" {}

variable "dev_vpc1_cidr_block" {
  description = "defaulr value of vpc1"
  default     = "10.0.0.0/16"
}

variable "dev_subnet1_cidr_block" {
  description = "defaulr value of subnet1"
  default     = "10.0.1.0/24"
}