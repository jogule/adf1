# Get current public IP
data "http" "current_ip" {
  url = "https://ipv4.icanhazip.com"
}

# Get current Azure client configuration
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "infra_rg" {
  name     = local.infra_rg
  location = local.location
}

resource "azurerm_resource_group" "datalake_rg" {
  name     = local.datalake_rg
  location = local.location
}

resource "azurerm_resource_group" "adf_rg" {
  name     = local.adf_rg
  location = local.location
}

resource "azurerm_resource_group" "sql_rg" {
  name     = local.sql_rg
  location = local.location
}

# Key Vault for storing SQL password
resource "azurerm_key_vault" "key_vault" {
  name                      = "kv-${local.sufix}"
  location                  = local.location
  resource_group_name       = azurerm_resource_group.infra_rg.name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "standard"
  purge_protection_enabled  = false
  enable_rbac_authorization = true

  # Network access restrictions
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = [local.current_ip]
  }
}

# RBAC role assignment for Key Vault Secrets Officer
resource "azurerm_role_assignment" "key_vault_secrets_officer" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# RBAC role assignment for ADF to access Key Vault
resource "azurerm_role_assignment" "adf_key_vault_access" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_data_factory.data_factory.identity[0].principal_id
}

# Secret for storing the data lake storage account connection string
resource "azurerm_key_vault_secret" "datalake_connection_string" {
  name         = "datalake-connection-string"
  value        = azurerm_storage_account.storage_account.primary_connection_string
  key_vault_id = azurerm_key_vault.key_vault.id

  depends_on = [
    azurerm_role_assignment.key_vault_secrets_officer,
    azurerm_storage_account.storage_account
  ]
}

# Output current IP for verification
output "current_public_ip" {
  description = "Current public IP address used for Key Vault access"
  value       = local.current_ip
}

# Output the Key Vault secret name for the data lake connection string
output "datalake_connection_string_secret_name" {
  description = "Name of the Key Vault secret containing the data lake connection string"
  value       = azurerm_key_vault_secret.datalake_connection_string.name
}

