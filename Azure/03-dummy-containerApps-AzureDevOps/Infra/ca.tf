resource "azurerm_log_analytics_workspace" "logAnalytics_dev_we_01" {
  name                = "la-${var.development_environment_short}-dwh-${var.region_short}-01"
  location            = data.azurerm_resource_group.eraki_containerApps_us1_rg_1001.location
  resource_group_name = data.azurerm_resource_group.eraki_containerApps_us1_rg_1001.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = merge(
    local.all_tage
  )
}

resource "azurerm_container_app_environment" "ContinerAppsEnv_dev_we_01" {
  name                       = "caev-${var.development_environment_short}-dwh-${var.region_short}-01"
  location                   = data.azurerm_resource_group.eraki_containerApps_us1_rg_1001.location
  resource_group_name        = data.azurerm_resource_group.eraki_containerApps_us1_rg_1001.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logAnalytics_dev_we_01.id
  tags = merge(
    local.all_tage
  )
}

resource "azurerm_container_app" "ContainerApps_dev_we_01" {
  name                         = "capp-${var.development_environment_short}-dwh-${var.region_short}-01"
  container_app_environment_id = azurerm_container_app_environment.ContinerAppsEnv_dev_we_01.id
  resource_group_name          = data.azurerm_resource_group.eraki_containerApps_us1_rg_1001.name
  #   location                     = data.azurerm_resource_group.eraki_containerApps_us1_rg_1001.location
  revision_mode = "Single"

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  tags = merge(
    local.all_tage
  )
}
