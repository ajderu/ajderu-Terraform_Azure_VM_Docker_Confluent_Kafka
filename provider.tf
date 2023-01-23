terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.38.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "e41dbaa4-dee2-46f5-af6a-474e47050169"
  client_id       = "756b6a1e-3d3c-4463-a26e-825c45cf2936"
  client_secret   = "5Pa8Q~5b4VXlB~Bt5fPi6779o2hbVcQBMUyMgdrp"
  tenant_id       = "b30b2f3c-ce2a-4b21-bffd-b18c051ccfee"
}