locals {
  rg_name = format("eraki-%s-%s-rg", var.environment, var.sysrole)
  vnet_name = format("eraki-%s-%s-vnet", var.environment, var.sysrole)
  subnet_name = format("eraki-%s-%s-subnet", var.environment, var.sysrole)
  nsg_name = format("eraki-%s-%s-nsg", var.environment, var.sysrole)
  vm_name = format("eraki-%s-%s-vm", var.environment, var.sysrole)
  webapp_name = format("eraki-%s-%s-webapp", var.environment, var.sysrole)
  private_dns_zone_name = format("eraki-%s-%s-pdz", var.environment, var.sysrole)
  private_endpoint_name = format("eraki-%s-%s-pe", var.environment, var.sysrole)
}

output "rg_name" { value = local.rg_name }
output "vnet_name" { value = local.vnet_name }
output "subnet_name" { value = local.subnet_name }
output "nsg_name" { value = local.nsg_name }
output "vm_name" { value = local.vm_name }
output "webapp_name" { value = local.webapp_name }
output "private_dns_zone_name" { value = local.private_dns_zone_name }
output "private_endpoint_name" { value = local.private_endpoint_name }