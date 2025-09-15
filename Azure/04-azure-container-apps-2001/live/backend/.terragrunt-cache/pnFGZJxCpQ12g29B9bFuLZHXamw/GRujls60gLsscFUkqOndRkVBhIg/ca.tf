resource "azurerm_container_app" "eraki_container_apps_us_2001" {
  # for_each = var.containerapps
  # name                         = "capp-${var.development_environment_short}-frontend-${var.region_short}-01"
  name                         = "capp-${var.development_environment_short}-${var.capps_application_name}-${var.region_short}-01"
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  #   location                     = data.azurerm_resource_group.eraki_containerApps_us1_rg_1001.location
  revision_mode = "Single"

  template {
    container {
      name   = var.container-name
      image  = var.container-image
      cpu    = var.container-cpu
      memory = var.container-memory

      dynamic "env" {
        # for_each = template.value.env != null ? template.value.env : []
        # for_each = coalesce(lookup(template.value[0], "env", null), [])
        for_each = lookup(var.container-env-vars, var.container-name, [])
        content {
          name  = env.value.name
          value = env.value.value
        }
      }
    }
  }
  ingress {
    external_enabled = var.container-external-enable
    target_port      = var.container-target-port
    transport        = var.container-transport

    traffic_weight {
      latest_revision = var.container-latest-revision
      percentage      = var.container-precentage
    }
  }
  tags = local.all_tags
}
