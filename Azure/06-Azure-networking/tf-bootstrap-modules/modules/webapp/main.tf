resource "azurerm_service_plan" "service_plan" {
	name                = coalesce(var.plan_name, "${var.name}-plan")
	location            = var.region
	resource_group_name = var.resource_group_name

	os_type = var.os_type

	sku_name = var.sku_size

	tags = var.tags
}

resource "azurerm_linux_web_app" "app_service" {
	name                = var.name
	location            = var.region
	resource_group_name = var.resource_group_name
	service_plan_id     = azurerm_service_plan.service_plan.id
	public_network_access_enabled = false

	site_config {
		always_on = true
	}

	tags = var.tags
}

resource "azurerm_network_security_group" "webapp_nsg" {
	name                = "${var.name}-nsg"
	location            = var.region
	resource_group_name = var.resource_group_name
	tags = var.tags
}
resource "azurerm_network_security_rule" "allow_80_for_endpoint" {
  name                        = "Allow-80-From-enpoint"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = var.private_endpoint_ip
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.webapp_nsg.name
  resource_group_name         = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "webapp_pe_nsg_assoc" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.webapp_nsg.id
}
