# private endpoint
resource "azurerm_private_endpoint" "pe" {
  name                = var.private_endpoint_name
  location            = var.region
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.private_endpoint_name}-psc"
    private_connection_resource_id = var.private_connection_resource_id
    is_manual_connection           = false
    subresource_names              = var.subresource_names
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "webapp_nsg" {
	name                = "${var.private_endpoint_name}-nsg"
	location            = var.region
	resource_group_name = var.resource_group_name
	tags = var.tags
}
resource "azurerm_network_security_rule" "allow_80_for_endpoint" {
  name                        = "Allow-80"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = azurerm_private_endpoint.pe.private_service_connection[0].private_ip_address
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.webapp_nsg.name
  resource_group_name         = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "webapp_pe_nsg_assoc" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.webapp_nsg.id
}
