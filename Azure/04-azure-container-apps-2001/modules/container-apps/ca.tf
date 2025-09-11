resource "azurerm_container_app_environment" "eraki_capp_environment_us_2001" {
  name                       = "cappenv-${var.development_environment_short}-main-${var.region_short}-01"
  location                   = azurerm_resource_group.eraki_containerApps_us_rg_2001.location
  resource_group_name        = azurerm_resource_group.eraki_containerApps_us_rg_2001.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.eraki_log_analytics_us_2001.id
  tags                       = local.all_tags
}

resource "azurerm_container_app" "eraki_container_apps_us_2001" {
  # for_each = var.containerapps
  # name                         = "capp-${var.development_environment_short}-frontend-${var.region_short}-01"
  name                         = "capp-${var.development_environment_short}-${each.key}-${var.region_short}-01"
  container_app_environment_id = azurerm_container_app_environment.eraki_capp_environment_us_2001.id
  resource_group_name          = azurerm_resource_group.eraki_containerApps_us_rg_2001.name
  #   location                     = data.azurerm_resource_group.eraki_containerApps_us1_rg_1001.location
  revision_mode = "Single"

  template {
    container {
      name   = var.template.name
      image  = var.template.image
      cpu    = var.template.cpu
      memory = var.template.memory

      dynamic "env" {
        # for_each = template.value.env != null ? template.value.env : []
        # for_each = coalesce(lookup(template.value[0], "env", null), [])
        for_each = lookup(var.ca_template, "env", [])
        content {
          name  = env.value.name
          value = env.value.value
        }
      }
    }
  }
  ingress {
    external_enabled = var.ca_ingress.external_enabled
    target_port      = var.ca_ingress.target_port
    transport        = var.ca_ingress.transport

    dynamic "traffic_weight" {
      for_each = var.ca_ingress.traffic_weight
      content {
        latest_revision = traffic_weight.value.latest_revision
        percentage      = traffic_weight.value.percentage
      }
    }
  }
  tags = local.all_tags
}
