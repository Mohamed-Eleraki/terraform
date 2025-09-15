terraform {
  source = "../../modules/container-apps"
}

include {
  path = find_in_parent_folders()
}

dependency "container-env" {
  config_path = "../container-env"
}

inputs = {
  development_environment_short = "dev"
  capps_application_name        = "backend"
  region                        = "East US"
  region_short                  = "us"
  container_app_environment_id  = dependency.container-env.outputs.containerapps_environment_id
  resource_group_name           = "RG-dev-us-capp"
  container-name                = "backend"
  container-image               = "ghcr.io/houssemdellai/containerapps-album-backend:v1"
  container-cpu                 = 0.25
  container-memory              = "0.5Gi"
  container-env-vars = {
    backend = [
      {
        name  = "DB_HOST"
        value = "db.dev.internal"
      },
      {
        name  = "LOG_LEVEL"
        value = "debug"
      }
    ]
  }

  container-external-enable = true
  container-target-port     = 3500
  container-transport       = "auto"

  container-latest-revision = true
  container-precentage      = 100

  tags = {
    project = "eraki"
    env     = "dev"
  }
}
