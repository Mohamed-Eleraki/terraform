terraform {
  source = "../modules/container-env"
}

include {
  path = find_in_parent_folders()
}

# dependencies {
#   paths = "../log-analytics"
# }

dependency "log-analytics" {
  config_path = "../log-analytics"

  # mock_outputs = {
  #   resource_group_name = "RG_dummy_input"
  #   log_analytics_id    = "dummy_input"
  #   skip_outputs        = false
  # }
}

inputs = {
  development_environment_short = "dev"
  region_short                  = "us"
  region                        = "East US"
  resource_group_name           = "RG-dev-us-capp"
  log_analytics_id              = dependency.log-analytics.outputs.log_analytics_id
  tags = {
    project = "eraki"
    env     = "dev"
  }
}
