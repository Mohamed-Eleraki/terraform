locals {
#   src_container_sas_url = "https://${azurerm_storage_account.eraki_northeurope_sg_test_1001.name}.blob.core.windows.net/${azurerm_storage_container.eraki_northeurope_sg_container1_test_1001.name}?${azurerm_storage_account_sas.source_container_sas.sas}"
#   dst_container_sas_url = "https://${azurerm_storage_account.eraki_northeurope_sg_test_1001.name}.blob.core.windows.net/${azurerm_storage_container.eraki_northeurope_sg_container2_test_1001.name}?${azurerm_storage_account_sas.dest_container_sas.sas}"

  common_tags = {
    environment = "test"
    company     = var.company_name
    region      = var.region_short
    solution    = var.solution_name
  }
}