region                        = "East US"
container_registry_short      = "cregis"
development_environment_short = "d"
region_shot                   = "us"
capps_application_name        = "container-apps"

containerapps = {
  "backend" = {
    name = "backend"
    template = [
      {
        name   = "backend-container"
        image  = "ghcr.io/houssemdellai/containerapps-album-backend:v1"
        cpu    = 0.25
        memory = "0.5Gi"
      }
    ]
    ingress = {
      external_enabled = true
      target_port      = 3500
      transport        = "auto"
      traffic_weight = [
        {
          latest_revision = true
          percentage      = 100
        }
      ]
    }
  },

  "frontend" = {
    name = "frontend"
    template = [
      {
        name   = "frontend-container"
        image  = "ghcr.io/houssemdellai/containerapps-album-frontend:v1"
        cpu    = 0.25
        memory = "0.5Gi"
        env = [{
          name  = "API_BASE_URL"
          value = "https://capp-d-backend-us-01.icymushroom-c5a30694.eastus.azurecontainerapps.io"
        }]
      }
    ]
    ingress = {
      external_enabled = true
      target_port      = 3000
      transport        = "auto"
      traffic_weight = [
        {
          latest_revision = true
          percentage      = 100
        }
      ]
    }
  },
}
