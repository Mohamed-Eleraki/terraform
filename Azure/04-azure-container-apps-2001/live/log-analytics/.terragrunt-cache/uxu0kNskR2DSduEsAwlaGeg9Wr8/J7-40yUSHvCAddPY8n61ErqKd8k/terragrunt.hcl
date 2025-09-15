terraform {
  source = "../../modules/log-analytics"
}

include {
  path = find_in_parent_folders()
}

# dependency "resource-group" {
#   config_path = "../resource-group"

#   # mock_outputs = {
#   #   resouce_group_location = "eastus"
#   #   resource_group_name     = "RG-dev-us-capp"
#   # }
# }

dependencies {
  paths = ["../resource-group"]
}

inputs = {
  development_environment_short = "dev"
  region_short                  = "us"
  # region                        = dependency.resource-group.outputs.resouce_group_location
  # resource_group_name           = dependency.resource-group.outputs.resource_group_name
  region              = "East US"
  resource_group_name = "RG-dev-us-capp"
  tags = {
    project = "eraki"
    env     = "dev"
  }
}
