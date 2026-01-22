resource "azurerm_resource_group" "rg_module" {
  name     = var.resource_group_name
  location = var.region
  tags = var.tags
}