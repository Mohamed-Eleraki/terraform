resource "azurerm_container_registry" "eraki_container_registry_us_2001" {
  name                = "${var.container_registry_short}${var.development_environment_short}main${var.region_short}01"
  resource_group_name = azurerm_resource_group.eraki_containerApps_us_rg_2001.name
  location            = azurerm_resource_group.eraki_containerApps_us_rg_2001.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = local.all_tags
}
