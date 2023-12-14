terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.56.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "mgmtgroup" {
  name = "test"
  location = "centralindia"
}

resource "azurerm_management_group" "root" {
  display_name = "TenantRootGroup"

  subscription_ids = [
    1c51efa2-3c43-4213-a888-f52bf45afc67,
  ]
}

resource "azurerm_management_group" "child" {
  display_name               = "DATAX"
  parent_management_group_id = azurerm_management_group.root.id
  subscription_ids = [
    1c51efa2-3c43-4213-a888-f52bf45afc67,
  ]
  # other subscription IDs can go here
}
