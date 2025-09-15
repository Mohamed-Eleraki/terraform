terraform {
  source = "../../modules/resource-group"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  development_environment_short = "dev"
  region_short                  = "us"
  capps_application_name        = "capps"
  region                        = "East US"
  tags = {
    project = "eraki"
    env     = "dev"
  }
}
