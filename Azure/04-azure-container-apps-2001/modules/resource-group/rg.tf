resource "azurerm_resource_group" "eraki_containerApps_us_rg_2001" {
  name     = "RG-${var.development_environment_short}-${var.region_short}-${var.capps_application_name}"
  location = var.region
  tags     = local.all_tags
}
