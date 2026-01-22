##################
# Naming modules #
##################
module "naming_hub1_netspoke_rg" {
  source      = "../../tf-bootstrap-modules/modules/naming"
  environment = "hub1"
  sysrole     = "netspoke"
}

module "naming_hub2_netspoke_rg" {
  source      = "../../tf-bootstrap-modules/modules/naming"
  environment = "hub2"
  sysrole     = "netspoke"
}

module "naming_hub1_netspoke_vnet" {
  source      = "../../tf-bootstrap-modules/modules/naming"
  environment = "hub1"
  sysrole     = "netspoke"
}

module "naming_hub2_netspoke_vnet" {
  source      = "../../tf-bootstrap-modules/modules/naming"
  environment = "hub2"
  sysrole     = "netspoke"
}

module "naming_hub1_netspoke_subnet" {
  source      = "../../tf-bootstrap-modules/modules/naming"
  environment = "hub1"
  sysrole     = "netspoke"
}

module "naming_hub2_netspoke_subnet" {
  source      = "../../tf-bootstrap-modules/modules/naming"
  environment = "hub2"
  sysrole     = "netspoke"
}

module "naming_vm" {
  source      = "../../tf-bootstrap-modules/modules/naming"
  environment = "hub1"
  sysrole     = "shared"
}

module "naming_hub1_prv_dnszone" {
  source      = "../../tf-bootstrap-modules/modules/naming"
  environment = "hub1"
  sysrole     = "netspoke"
}

module "naming_hub2_prv_dnszone" {
  source      = "../../tf-bootstrap-modules/modules/naming"
  environment = "hub1"
  sysrole     = "netspoke"
}

module "naming_webapp" {
  source      = "../../tf-bootstrap-modules/modules/naming"
  environment = "hub1"
  sysrole     = "shared"
}

module "naming_prv_endpoint" {
  source      = "../../tf-bootstrap-modules/modules/naming"
  environment = "hub1"
  sysrole     = "netspoke"
}

##################
# Resource Group #
##################
module "rg_hub1_netspoke" {
  source              = "../../tf-bootstrap-modules/modules/rg"
  resource_group_name = module.naming_hub1_netspoke_rg.rg_name
  region              = var.region
  tags                = local.all_tags
}

module "rg_hub2_netspoke" {
  source              = "../../tf-bootstrap-modules/modules/rg"
  resource_group_name = module.naming_hub2_netspoke_rg.rg_name
  region              = var.region
  tags                = local.all_tags
}

###################
# Virtual Network #
###################
module "vnet_hub1_netspoke" {
  source                          = "../../tf-bootstrap-modules/modules/vnet"
  name                            = module.naming_hub1_netspoke_vnet.vnet_name
  region                          = var.region
  resource_group_name             = module.rg_hub1_netspoke.resource_group_name
  address_space                   = ["10.1.0.0/16"]
  subnet_name                     = module.naming_hub1_netspoke_subnet.subnet_name
  subnet_prefix                   = "10.1.0.0/16"
  default_outbound_access_enabled = true
  tags                            = local.all_tags
}
module "vnet_hub2_netspoke" {
  source                          = "../../tf-bootstrap-modules/modules/vnet"
  name                            = module.naming_hub2_netspoke_vnet.vnet_name
  region                          = var.region
  resource_group_name             = module.rg_hub2_netspoke.resource_group_name
  address_space                   = ["10.2.0.0/16"]
  subnet_name                     = module.naming_hub2_netspoke_subnet.subnet_name
  subnet_prefix                   = "10.2.0.0/16"
  default_outbound_access_enabled = false
  tags                            = local.all_tags
}

###################
# Virtual Machine #
###################
module "vm_hub1" {
  source              = "../../tf-bootstrap-modules/modules/vm"
  vm_name             = module.naming_vm.vm_name
  region              = var.region
  resource_group_name = module.rg_hub1_netspoke.resource_group_name
  subnet_id           = module.vnet_hub1_netspoke.subnet_id
  # Read the SSH public key from a variable provided to the environment
  # (do NOT call file() with an absolute path here — Terraform only allows
  # file() for files inside the configuration). Provide the key via
  # dev.tfvars, -var, or the TF_VAR_admin_ssh_key env var.
  # admin_ssh_key = var.admin_ssh_key
  tags          = local.all_tags
}

####################
# Private DNS Zone #
####################
module "private_dns_zone_hub1" {
  source                = "../../tf-bootstrap-modules/modules/private_dns_zone"
  private_dns_zone_name = "netspoke.hub1.internal"
  resource_group_name   = module.rg_hub1_netspoke.resource_group_name
  virtual_network_id    = module.vnet_hub1_netspoke.vnet_id
  webapp_private_ip     = module.private_endpoint_hub2.private_endpoint_private_ip
  tags                  = local.all_tags
}

module "private_dns_zone_hub2" {
  source                = "../../tf-bootstrap-modules/modules/private_dns_zone"
  private_dns_zone_name = "netspoke.hub2.internal"
  resource_group_name   = module.rg_hub2_netspoke.resource_group_name
  virtual_network_id    = module.vnet_hub2_netspoke.vnet_id
  webapp_private_ip     = module.private_endpoint_hub2.private_endpoint_private_ip
  tags                  = local.all_tags
}

###################
# Web Application #
###################
module "webapp_hub2" {
  source              = "../../tf-bootstrap-modules/modules/webapp"
  name                = module.naming_webapp.webapp_name
  region              = var.region
  resource_group_name = module.rg_hub2_netspoke.resource_group_name
  private_endpoint_ip = module.private_endpoint_hub2.private_endpoint_private_ip
  subnet_id           = module.vnet_hub2_netspoke.subnet_id
  tags                = local.all_tags
}

####################
# Private Endpoint #
####################
module "private_endpoint_hub2" {
  source                         = "../../tf-bootstrap-modules/modules/private_endpoint"
  private_endpoint_name          = module.naming_prv_endpoint.private_endpoint_name
  region                         = var.region
  subnet_id                      = module.vnet_hub2_netspoke.subnet_id
  resource_group_name            = module.rg_hub2_netspoke.resource_group_name
  private_connection_resource_id = module.webapp_hub2.webapp_id
  subresource_names              = ["sites"]
  tags                           = local.all_tags
}