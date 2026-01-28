# list all output 
output "private_dns_zone_id" {
  description = "ID of the created private DNS zone"
  value       = azurerm_private_dns_zone.pdz.id
}
output "private_dns_zone_name" {
  description = "Name of the created private DNS zone"
  value       = azurerm_private_dns_zone.pdz.name
}