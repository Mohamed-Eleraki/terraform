output "containerapps_environment_id" {
  description = "The ID of the Container Apps Environment"
  value       = azurerm_container_app_environment.containerapps_env.id

}
output "resource_group_name" {
  value = azurerm_resource_group.eraki_containerApps_us_rg_2001.name
}
output "resouce_group_location" {
  value = azurerm_resource_group.eraki_containerApps_us_rg_2001.location
}
output "log_analytics_id" {
  value = azurerm_log_analytics_workspace.eraki_log_analytics_us_2001.id
}
output "log_analytics_name" {
  value = azurerm_log_analytics_workspace.eraki_log_analytics_us_2001.name
}
output "container_app_fqdn" {
  value       = azurerm_container_app.eraki_container_apps_us_2001.latest_revision_fqdn
  description = "The FQDN of the container app"
}
