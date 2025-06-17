# # Random password for SQL Server
# resource "random_password" "sql_password" {
#   length  = 16
#   special = true
# }

# # Store SQL password in Key Vault
# resource "azurerm_key_vault_secret" "sql_password" {
#   name         = "sql-admin-password"
#   value        = random_password.sql_password.result
#   key_vault_id = azurerm_key_vault.key_vault.id

#   depends_on = [azurerm_role_assignment.key_vault_secrets_officer]
# }

# # SQL Server
# resource "azurerm_mssql_server" "sql_server" {
#   name                         = "sql-${local.sufix}"
#   resource_group_name          = azurerm_resource_group.adf_rg.name
#   location                     = local.location
#   version                      = "12.0"
#   administrator_login          = "sqladmin"
#   administrator_login_password = random_password.sql_password.result
# }

# # SQL Database (Serverless)
# resource "azurerm_mssql_database" "sql_database" {
#   name      = "sqldb-${local.sufix}"
#   server_id = azurerm_mssql_server.sql_server.id
#   sku_name  = "GP_S_Gen5_1"

#   auto_pause_delay_in_minutes = 60
#   min_capacity                = 0.5
# }

# # Firewall rule for Azure services
# resource "azurerm_mssql_firewall_rule" "azure_services" {
#   name             = "AllowAzureServices"
#   server_id        = azurerm_mssql_server.sql_server.id
#   start_ip_address = "0.0.0.0"
#   end_ip_address   = "0.0.0.0"
# }

# # Firewall rule for your current IP
# resource "azurerm_mssql_firewall_rule" "current_ip" {
#   name             = "AllowCurrentIP"
#   server_id        = azurerm_mssql_server.sql_server.id
#   start_ip_address = local.current_ip
#   end_ip_address   = local.current_ip
# }
