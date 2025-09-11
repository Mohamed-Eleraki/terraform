resource "azurerm_container_app_environment" "eraki_capp_environment_us_2001" {
  name                       = "cappenv-${var.development_environment_short}-main-${var.region_short}-01"
  location                   = var.region
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_id
  tags                       = local.all_tags
}
