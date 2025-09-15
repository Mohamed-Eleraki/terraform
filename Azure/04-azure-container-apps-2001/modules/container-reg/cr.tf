resource "azurerm_container_registry" "eraki_container_registry_us_2001" {
  name                = "${var.container_registry_short}${var.development_environment_short}main${var.region_short}01"
  resource_group_name = var.resource_group_name
  location            = var.region
  sku                 = "Basic"
  admin_enabled       = false
  tags                = local.all_tags
}
