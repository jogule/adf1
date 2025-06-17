locals {
    resource_group_name = "adf1-rg"
    location            = "eastus"
    sufix              = "jgl926"
}

resource "azurerm_resource_group" "resource_group" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "st${local.sufix}"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
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

resource "azurerm_data_factory" "data_factory" {
  name                = "adf-${local.sufix}"
  location            = local.location
  resource_group_name = azurerm_resource_group.resource_group.name

  github_configuration {
    account_name       = "jogule"
    branch_name        = "main"
    git_url            = "https://github.com"
    publishing_enabled = true
    repository_name    = "adf1"
    root_folder        = "/"
  }
}
