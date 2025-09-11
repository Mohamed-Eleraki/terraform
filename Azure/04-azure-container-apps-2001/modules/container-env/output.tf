output "containerapps_environment_id" {
  description = "The ID of the Container Apps Environment"
  value       = azurerm_container_app_environment.containerapps_env.id
}
output "containerapps_environment_name" {
  description = "The name of the Container Apps Environment"
  value       = azurerm_container_app_environment.containerapps_env.name
}
