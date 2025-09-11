terraform {
  source = "../modules/container-apps"
}

include {
  path = find_in_parent_folders()
}

dependency "container_vars" {
  config_path = "../backend"
}

dependency "backend" {
  config_path = "../backend"
}

inputs = {
  app_name                      = "frontend"
  development_environment_short = "dev"
  region_short                  = "us"

  resource_group_name          = dependency.container_vars.outputs.resource_group_name
  container_app_environment_id = dependency.container_vars.outputs.containerapps_environment_id

  template = [{
    name   = "frontend"
    image  = "ghcr.io/houssemdellai/containerapps-album-frontend:v1"
    cpu    = 0.5
    memory = "0.5Gi"
    env = [
      { name = "API_BASE_URL", value = "https://${dependency.backend.outputs.container_app_fqdn}" }
    ]
  }]

  ingress = {
    external_enabled = true
    target_port      = 3000
    transport        = "auto"
    traffic_weight   = [{ latest_revision = true, percentage = 100 }]
  }

  tags = {
    project = "eraki"
    env     = "dev"
  }
}
