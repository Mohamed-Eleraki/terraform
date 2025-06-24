# resource "azurerm_service_plan" "eraki_northeurope_service_app_1001" {
#   name                = "${var.company_name}-${var.region_short}-service-app-1001"
#   resource_group_name = azurerm_resource_group.eraki_northeurope_rg_func_1001
#   location            = azurerm_resource_group.eraki_northeurope_rg_func_1001.location
#   os_type             = "Linux"
#   sku_name            = "Y1"

#   #   sku_name            = "P1v2"
#   #   worker_count        = 2 # Minimum number of instances
# }

# resource "azurerm_linux_function_app" "eraki_northeurope_func_bcopy_1001" {
#   name                       = "${var.company_name}-${var.region_short}-func-blob-copy"
#   location                   = azurerm_resource_group.eraki_northeurope_rg_func_1001.location
#   resource_group_name        = azurerm_resource_group.eraki_northeurope_rg_func_1001.name
#   service_plan_id            = azurerm_service_plan.eraki_northeurope_service_app_1001.id
#   storage_account_name       = azurerm_storage_account.eraki_northeurope_sg_func_1001.name
#   storage_account_access_key = azurerm_storage_account.eraki_northeurope_sg_func_1001.primary_access_key

#   site_config {
#     application_stack {
#       #   python_version = "3.9"
#       powershell_core_version = "7"
#     }
#   }

#   #   app_settings = {
#   #     FUNCTIONS_WORKER_RUNTIME  = "python"
#   #     AzureWebJobsStorage       = azurerm_storage_account.function_sa.primary_connection_string
#   #     SRC_STORAGE_CONNECTION    = "<source-blob-connection-string>"
#   #     DST_STORAGE_CONNECTION    = "<destination-blob-connection-string>"
#   #     SOURCE_CONTAINER          = "<source-container-name>"
#   #     DEST_CONTAINER            = "<destination-container-name>"
#   #   }

#   app_settings = {
#     FUNCTIONS_WORKER_RUNTIME = "powershell"
#     AzureWebJobsStorage      = azurerm_storage_account.eraki_northeurope_sg_func_1001.primary_connection_string
#     SRC_STORAGE_CONNECTION   = azurerm_storage_account.eraki_northeurope_sg_test_1001.primary_connection_string
#     DST_STORAGE_CONNECTION   = azurerm_storage_account.eraki_northeurope_sg_test_1001.primary_connection_string
#     SOURCE_CONTAINER         = azurerm_storage_container.eraki_northeurope_sg_container1_test_1001.name
#     DEST_CONTAINER           = azurerm_storage_container.eraki_northeurope_sg_container2_test_1001.name

#     # SRC_CONTAINER_SAS_URL = local.src_container_sas_url
#     # DST_CONTAINER_SAS_URL = local.dst_container_sas_url
#     SRC_CONTAINER_SAS_URL = data.azurerm_storage_account_sas.source_container_sas.sas
#     DST_CONTAINER_SAS_URL = data.azurerm_storage_account_sas.dest_container_sas.sas
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   public_network_access_enabled = false
#   https_only                    = true
# }

# resource "azurerm_storage_account_sas" "source_container_sas" {
#   connection_string = azurerm_storage_account.eraki_northeurope_sg_test_1001.primary_connection_string

#   https_only             = true
#   start                  = "2025-05-15T00:00:00Z"
#   expiry                 = "2025-06-15T00:00:00Z"
#   resource_types         = ["object", "container"]
#   services               = ["b"]
#   permissions            = "rl" # read and list permissions
#   canonicalized_resource = "/blob/${azurerm_storage_account.eraki_northeurope_sg_test_1001.name}/${azurerm_storage_container.eraki_northeurope_sg_container1_test_1001.name}"
# }

# resource "azurerm_storage_account_sas" "dest_container_sas" {
#   connection_string = azurerm_storage_account.eraki_northeurope_sg_test_1001.primary_connection_string

#   https_only             = true
#   start                  = "2025-05-15T00:00:00Z"
#   expiry                 = "2025-06-15T00:00:00Z"
#   resource_types         = ["container", "object"]
#   services               = ["b"]
#   permissions            = "w" # write permission for destination
#   canonicalized_resource = "/blob/${azurerm_storage_account.eraki_northeurope_sg_test_1001.name}/${azurerm_storage_container.eraki_northeurope_sg_container2_test_1001.name}"
# }

# resource "null_resource" "deploy_function_code" {
#   depends_on = [azurerm_linux_function_app.eraki_northeurope_func_bcopy_1001]

#   provisioner "local-exec" {
#     command = <<EOT
#       cd ./source
#       zip -r ../functionapp.zip .
#       az functionapp deployment source config-zip \
#         --resource-group ${azurerm_resource_group.eraki_northeurope_rg_func_1001.name} \
#         --name ${azurerm_linux_function_app.eraki_northeurope_func_bcopy_1001.name} \
#         --src ../functionapp.zip
#     EOT
#   }
# }

# data "azurerm_storage_account_sas" "source_container_sas" {
#   connection_string = azurerm_storage_account.eraki_northeurope_sg_test_1001.primary_connection_string

#   https_only             = true
#   start                  = "2025-05-15T00:00:00Z"
#   expiry                 = "2025-06-15T00:00:00Z"
#   resource_types         = ["object", "container"]
#   services               = ["b"]
#   permissions            = "rl" # read and list permissions
#   canonicalized_resource = "/blob/${azurerm_storage_account.eraki_northeurope_sg_test_1001.name}/${azurerm_storage_container.eraki_northeurope_sg_container1_test_1001.name}"
# }

# data "azurerm_storage_account_sas" "dest_container_sas" {
#   connection_string = azurerm_storage_account.eraki_northeurope_sg_test_1001.primary_connection_string

#   https_only             = true
#   start                  = "2025-05-15T00:00:00Z"
#   expiry                 = "2025-06-15T00:00:00Z"
#   resource_types         = ["container", "object"]
#   services               = ["b"]
#   permissions            = "w" # write permission for destination
#   canonicalized_resource = "/blob/${azurerm_storage_account.eraki_northeurope_sg_test_1001.name}/${azurerm_storage_container.eraki_northeurope_sg_container2_test_1001.name}"
# }
