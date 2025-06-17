terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~> 4.0"
        }
    }
    required_version = ">= 1.5"
}

provider "azurerm" {
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id

    features {}
}

locals {
    resource_group_name = "adf1-rg"
    location            = "eastus"
}

resource "azurerm_resource_group" "example" {
  name     = local.resource_group_name
  location = local.location
}