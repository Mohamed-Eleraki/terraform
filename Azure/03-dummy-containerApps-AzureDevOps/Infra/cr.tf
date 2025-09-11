resource "azurerm_container_registry" "eraki_containerApps_us1_cr_1001" {
  name                = "${var.container_registry_short}${var.development_environment_short}dwh${var.region_short}01"
  resource_group_name = data.azurerm_resource_group.eraki_containerApps_us1_rg_1001.name
  location            = data.azurerm_resource_group.eraki_containerApps_us1_rg_1001.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = merge(
    local.all_tage
  )
}
