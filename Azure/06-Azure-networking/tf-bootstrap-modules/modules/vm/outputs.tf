output "vm_id" {
  description = "ID of the created virtual machine"
  value       = azurerm_virtual_machine.vm.id
}

output "network_interface_id" {
  description = "ID of the network interface used/created for the VM"
  value       = azurerm_network_interface.nic.id
}

output "private_ip" {
  description = "Private IP address assigned to the VM NIC"
  value       = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}

output "public_ip" {
  description = "Public IP address"
  value       = azurerm_public_ip.pip.ip_address
}
