# private dns zone
resource "azurerm_private_dns_zone" "pdz" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name

  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  name                  = "${var.private_dns_zone_name}-vnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.pdz.name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false
}

resource "azurerm_private_dns_a_record" "webapp_record" {
  name                = "webapp"
  zone_name           = azurerm_private_dns_zone.pdz.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [var.webapp_private_ip]
}