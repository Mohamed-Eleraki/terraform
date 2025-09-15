resource "azurerm_log_analytics_workspace" "eraki_log_analytics_us_2001" {
  name                = "logana-${var.development_environment_short}-main-${var.region_short}-01"
  location            = var.region
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30 # Minimum
  tags                = local.all_tags
}
