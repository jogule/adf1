resource "azurerm_data_factory" "data_factory" {
  name                = "adf-${local.sufix}"
  location            = local.location
  resource_group_name = azurerm_resource_group.adf_rg.name

  identity {
    type = "SystemAssigned"
  }

  github_configuration {
    account_name       = "jogule"
    branch_name        = "main"
    git_url            = "https://github.com"
    publishing_enabled = true
    repository_name    = "adf1"
    root_folder        = "/"
  }
}

# RBAC role assignment for ADF managed identity to access storage account
resource "azurerm_role_assignment" "adf_storage_blob_contributor" {
  scope                = azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.data_factory.identity[0].principal_id
}

