# list all output
output "private_endpoint_id" {
  description = "ID of the created private endpoint"
  value       = azurerm_private_endpoint.pe.id
}

output "private_endpoint_private_ip" {
  description = "Private IP address assigned to the private endpoint (first private service connection)"
  value       = azurerm_private_endpoint.pe.private_service_connection[0].private_ip_address
}