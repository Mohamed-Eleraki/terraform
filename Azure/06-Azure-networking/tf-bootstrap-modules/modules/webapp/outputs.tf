output "app_service_id" {
  description = "ID of the created App Service"
  value       = azurerm_linux_web_app.app_service.id
}

output "app_service_name" {
  description = "Name of the created App Service"
  value       = azurerm_linux_web_app.app_service.name
}

output "webapp_id" {
  description = "The ID of the Web App"
  value       = azurerm_linux_web_app.app_service.id
}

output "network_security_group_id" {
  description = "ID of the NSG created for the webapp"
  value       = azurerm_network_security_group.webapp_nsg.id
}