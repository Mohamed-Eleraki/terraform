output "containerapps_environment_id" {
  description = "The ID of the Container Apps Environment"
  value       = azurerm_container_app_environment.eraki_capp_environment_us_2001.id
}
output "containerapps_environment_name" {
  description = "The name of the Container Apps Environment"
  value       = azurerm_container_app_environment.eraki_capp_environment_us_2001.name
}
