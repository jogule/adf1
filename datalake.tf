resource "azurerm_storage_account" "storage_account" {
  name                     = "st${local.sufix}"
  resource_group_name      = azurerm_resource_group.datalake_rg.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# RBAC role assignment for Storage Blob Data Contributor (current user)
resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  scope                = azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_storage_container" "landing" {
  name                  = "landing"
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "sampledata" {
  name                  = "sampledata"
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

# Upload ZIP file to landing container
resource "null_resource" "upload_zip_file" {
  depends_on = [
    azurerm_storage_container.landing,
    azurerm_storage_account.storage_account,
    azurerm_role_assignment.storage_blob_data_contributor
  ]

  provisioner "local-exec" {
    command = <<-EOT
      # Wait for RBAC permissions to propagate
      echo "Waiting for RBAC permissions to propagate..."
      sleep 30
      
      # Upload the file
      az storage blob upload \
        --account-name st${local.sufix} \
        --container-name landing \
        --name Azure-Data-Factory-by-Example-Second-Edition-main.zip \
        --file ${path.module}/Azure-Data-Factory-by-Example-Second-Edition-main.zip \
        --auth-mode login \
        --overwrite
    EOT
  }

  # Trigger re-upload if the ZIP file changes
  triggers = {
    file_hash = filemd5("${path.module}/Azure-Data-Factory-by-Example-Second-Edition-main.zip")
  }
}
