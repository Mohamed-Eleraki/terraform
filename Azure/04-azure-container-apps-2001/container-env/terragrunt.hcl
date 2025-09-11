terraform {
  source = "../modules/container-env"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = "../log-analytics"
}

inputs = {
  development_environment_short = "dev"
  region_short                  = "us"
  region                      = "East US"
  resource_group_name           = "RG-dev-us-capps"
  log_analytics_workspace_id    = 
  tags = {
    project = "eraki"
    env     = "dev"
  }
}
