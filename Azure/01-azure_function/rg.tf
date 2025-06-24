resource "azurerm_resource_group" "eraki_northeurope_rg_test_1001" {
  name     = "${var.company_name}-${var.region_short}-rg-${var.solution_name}"
  location = var.region
  tags     = local.common_tags
}

resource "azurerm_resource_group" "eraki_northeurope_rg_func_1001" {
  name     = "${var.company_name}-${var.region_short}-rg-func_1001"
  location = var.region
  tags     = local.common_tags
}
