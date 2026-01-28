# list all output
output "resouce_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.rg_module.id
}
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.rg_module.name
}