resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

resource "azurerm_storage_account" "eraki_northeurope_sg_test_1001" {
  name                     = "tfstorage${random_integer.suffix.result}"
  resource_group_name      = azurerm_resource_group.eraki_northeurope_rg_test_1001.name
  location                 = var.region
  account_tier             = "Standard"
  access_tier              = "Hot"
  account_replication_type = "LRS"
  tags                     = local.common_tags
}

resource "azurerm_storage_container" "eraki_northeurope_sg_container1_test_1001" {
  depends_on            = [azurerm_storage_account.eraki_northeurope_sg_test_1001]
  name                  = "source"
  storage_account_name  = azurerm_storage_account.eraki_northeurope_sg_test_1001.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "eraki_northeurope_sg_container2_test_1001" {
  depends_on            = [azurerm_storage_account.eraki_northeurope_sg_test_1001]
  name                  = "destination"
  storage_account_name  = azurerm_storage_account.eraki_northeurope_sg_test_1001.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "eraki_northeurope_sg_blob1_test_1001" {
  name                   = "source_dir1/source_subdir1/.keep"
  storage_account_name   = azurerm_storage_account.eraki_northeurope_sg_test_1001.name
  storage_container_name = azurerm_storage_container.eraki_northeurope_sg_container1_test_1001.name
  type                   = "Block"
  source_content         = ""
}

resource "azurerm_storage_blob" "eraki_northeurope_sg_blob2_test_1001" {
  name                   = "source_dir1/source_subdir1/.keep"
  storage_account_name   = azurerm_storage_account.eraki_northeurope_sg_test_1001.name
  storage_container_name = azurerm_storage_container.eraki_northeurope_sg_container2_test_1001.name
  type                   = "Block"
  source_content         = ""
}

# Function Storage account
resource "azurerm_storage_account" "eraki_northeurope_sg_func_1001" {
  name                     = "tfstoragefunc${random_integer.suffix.result}"
  resource_group_name      = azurerm_resource_group.eraki_northeurope_rg_func_1001.name
  location                 = var.region
  account_tier             = "Standard"
  access_tier              = "Hot"
  account_replication_type = "LRS"
  tags                     = local.common_tags
}