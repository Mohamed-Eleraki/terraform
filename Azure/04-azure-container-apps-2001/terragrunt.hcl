remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = "eraki-containerApps-us1-rg-1001"
    storage_account_name = "erakitfstateaccount17108"
    container_name       = "containerappstfstate"
    key                  = "${path_relative_to_include()}/containerApps-terragrunt.tfstate"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "azurerm" {
  features {}
  subscription_id = "856880af-e2ac-41b2-b5fb-e7ebfe4d97bc"
}
EOF
}
