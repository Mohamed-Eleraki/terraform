terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "random" {}

# Dummy resource
resource "random_pet" "test" {
  length    = var.length
  separator = "-"
}

output "dummy_output" {
  value = random_pet.test.id
}
