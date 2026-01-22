resource "azurerm_public_ip" "pip" {
	name                = "${var.vm_name}-pip"
	location            = var.region
	resource_group_name = var.resource_group_name
	allocation_method   = "Static"
	sku = "Standard"
	tags                = var.tags
}

resource "azurerm_network_interface" "nic" {
	name                = "${var.vm_name}-nic"
	location            = var.region
	resource_group_name = var.resource_group_name
	ip_configuration {
		name                          = "internal"
		subnet_id                     = var.subnet_id
		private_ip_address_allocation = "Dynamic"
		public_ip_address_id          = azurerm_public_ip.pip.id
	}
	tags = var.tags
}

resource "azurerm_virtual_machine" "vm" {
	name                  = var.vm_name
	location              = var.region
	resource_group_name   = var.resource_group_name
	network_interface_ids = [azurerm_network_interface.nic.id]
	vm_size               = var.vm_size
	delete_data_disks_on_termination = true
    delete_os_disk_on_termination    = true

	storage_os_disk {
		name              = "${var.vm_name}-osdisk"
		caching           = "ReadWrite"
		create_option     = "FromImage"
		managed_disk_type = var.os_disk_type
		disk_size_gb      = var.os_disk_size_gb
	}
	storage_image_reference {
		publisher = var.image_publisher
		offer     = var.image_offer
		sku       = var.image_sku
		version   = var.image_version
	}
	os_profile {
		computer_name  = var.vm_name
		admin_username = var.admin_username
		admin_password = var.admin_password
	}

	os_profile_linux_config {
		disable_password_authentication = false

		# ssh_keys {
		# 	path     = "/home/${var.admin_username}/.ssh/authorized_keys"
		# 	key_data = var.admin_ssh_key
		# }
	}

	tags = var.tags
}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.vm_name}-nsg"
  location            = var.region
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
resource "azurerm_network_security_rule" "allow_ssh_any_where" {
  name                        = "Allow-SSH-From-Office"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
  resource_group_name         = var.resource_group_name
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}