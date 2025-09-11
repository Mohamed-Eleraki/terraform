terraform {
  source = "../modules/container-apps"
}

include {
  path = find_in_parent_folders()
}

dependency "container_vars" {
  config_path = "../container-env"
}

inputs = {
  app_name                      = "backend"
  development_environment_short = "dev"
  region_short                  = "us"

  resource_group_name          = dependency.container_vars.outputs.resource_group_name
  container_app_environment_id = dependency.container_vars.outputs.containerapps_environment_id

  template = [{
    name   = "backend"
    image  = "ghcr.io/houssemdellai/containerapps-album-backend:v1"
    cpu    = 0.25
    memory = "0.5Gi"
  }]

  ingress = {
    external_enabled = true
    target_port      = 3500
    transport        = "auto"
    traffic_weight   = [{ latest_revision = true, percentage = 100 }]
  }

  tags = {
    project = "eraki"
    env     = "dev"
  }
}
