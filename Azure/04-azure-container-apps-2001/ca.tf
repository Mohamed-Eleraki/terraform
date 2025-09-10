resource "azurerm_log_analytics_workspace" "eraki_log_analytics_us_2001" {
  name                = "logana-${var.development_environment_short}-main-${var.region_shot}-01"
  location            = azurerm_resource_group.eraki_containerApps_us_rg_2001.location
  resource_group_name = azurerm_resource_group.eraki_containerApps_us_rg_2001.name
  sku                 = "PerGB2018"
  retention_in_days   = 30 # Minimum

  tags = merge(
    local.all_tage
  )
}

resource "azurerm_container_app_environment" "eraki_capp_environment_us_2001" {
  name                       = "cappenv-${var.development_environment_short}-main-${var.region_shot}-01"
  location                   = azurerm_resource_group.eraki_containerApps_us_rg_2001.location
  resource_group_name        = azurerm_resource_group.eraki_containerApps_us_rg_2001.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.eraki_log_analytics_us_2001.id

  tags = merge(
    local.all_tage
  )
}


resource "azurerm_container_app" "eraki_container_apps_us_2001" {
  for_each = var.containerapps
  # name                         = "capp-${var.development_environment_short}-frontend-${var.region_shot}-01"
  name                         = "capp-${var.development_environment_short}-${each.key}-${var.region_shot}-01"
  container_app_environment_id = azurerm_container_app_environment.eraki_capp_environment_us_2001.id
  resource_group_name          = azurerm_resource_group.eraki_containerApps_us_rg_2001.name
  #   location                     = data.azurerm_resource_group.eraki_containerApps_us1_rg_1001.location
  revision_mode = "Single"

  dynamic "template" {
    for_each = [each.value.template]
    content {
      container {
        name   = template.value[0].name
        image  = template.value[0].image
        cpu    = template.value[0].cpu
        memory = template.value[0].memory

        dynamic "env" {
          # for_each = template.value.env != null ? template.value.env : []
          for_each = coalesce(lookup(template.value[0], "env", null), [])
          content {
            name  = env.value.name
            value = env.value.value
          }
        }
      }
      # env { # pass backend URL into frontend container
      #   name  = "API_BASE_URL"
      #   value = "https://${azurerm_container_app.eraki_container_apps_backend_us_2001.latest_revision_fqdn}"
      # }
    }
  }

  dynamic "ingress" {
    for_each = [each.value.ingress]
    content {
      external_enabled = ingress.value.external_enabled
      target_port      = ingress.value.target_port
      transport        = ingress.value.transport

      dynamic "traffic_weight" {
        for_each = ingress.value.traffic_weight
        content {
          latest_revision = traffic_weight.value["latest_revision"]
          percentage      = traffic_weight.value["percentage"]
        }
      }
    }
  }

  tags = merge(
    local.all_tage
  )
}
