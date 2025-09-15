terraform {
  source = "../../modules/container-apps"
}

include {
  path = find_in_parent_folders()
}

dependency "container-env" {
  config_path = "../container-env"
}

dependency "backend" {
  config_path = "../backend"
}

inputs = {
  development_environment_short = "dev"
  capps_application_name        = "frontend"
  region_short                  = "us"
  region                        = "East US"
  container_app_environment_id  = dependency.container-env.outputs.containerapps_environment_id
  resource_group_name           = "RG-dev-us-capp"
  container-name                = "frontend"
  container-image               = "ghcr.io/houssemdellai/containerapps-album-frontend:v1"
  container-cpu                 = 0.25
  container-memory              = "0.5Gi"
  container-env-vars = {
    frontend = [
      {
        name  = "API_BASE_URL"
        value = "https://${dependency.backend.outputs.container_app_fqdn}"
      },
      {
        name  = "LOG_LEVEL"
        value = "debug"
      }
    ]
  }
  container-external-enable = true
  container-target-port     = 3000
  container-transport       = "auto"

  container-latest-revision = true
  container-precentage      = 100

  tags = {
    project = "eraki"
    env     = "dev"
  }
}
