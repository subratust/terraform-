terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.56.0"
    }
  }
 backend "azurerm" {
    storage_account_name = "saimterraform"
    container_name       = "terraformstate"
    key                  = "mgmt.terraform.tfstate"
    sas_token = "?sv=2022-11-02&ss=bfqt&srt=c&sp=rwdlacupiytfx&se=2023-12-14T15:13:08Z&st=2023-12-14T07:13:08Z&spr=https&sig=Phml2d7niuiv4OdYYgSekgh674%2BoJ1wkErirfKWyYyE%3D"
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
