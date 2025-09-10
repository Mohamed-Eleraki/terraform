terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "eraki-containerApps-us1-rg-1001"
    storage_account_name = "erakitfstateaccount17108"
    container_name       = "containerappstfstate"
    key                  = "containerApps-terraform.tfstate"
    #   use_msi              = true # use Managed Identity
  }
}

provider "azurerm" {
  features {}
  subscription_id = "856880af-e2ac-41b2-b5fb-e7ebfe4d97bc"
}

