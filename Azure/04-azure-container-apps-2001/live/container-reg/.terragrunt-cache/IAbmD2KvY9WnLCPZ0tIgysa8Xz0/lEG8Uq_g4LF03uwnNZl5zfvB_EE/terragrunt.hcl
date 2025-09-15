terraform {
  source = "../../modules/container-reg"
}

include {
  path = find_in_parent_folders()
}

# dependencies {
#   paths = "../log-analytics"
# }

dependency "resource-group" {
  config_path = "../resource-group"

  # mock_outputs = {
  #   resource_group_name = "RG_dummy_input"
  #   log_analytics_id    = "dummy_input"
  #   skip_outputs        = false
  # }
}

inputs = {
  container_registry_short      = "contreg"
  development_environment_short = "dev"
  region_short                  = "us"
  resource_group_name           = dependency.resource-group.outputs.resource_group_name
  region                        = "East US"
  tags = {
    project = "eraki"
    env     = "dev"
  }
}
