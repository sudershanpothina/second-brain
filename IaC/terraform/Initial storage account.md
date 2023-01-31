```
create the storage account using local backend and after the creation of storage account switch the backend to the new storage account

providers.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
}


# Creates random string for the Unique ID for the Azure Storage Account Name
resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

# Import Resource Group if using ACG's Azure Sandbox
resource "azurerm_resource_group" "guru" {
  name     = "624-ec327beb-setting-up-azure-storage-to-be-used-f"
  location = "southcentralus"
  tags     = {
   environment = "dev"
  }
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.guru.name
  location                 = azurerm_resource_group.guru.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}


# Outputs 
output "storage_account_name" { 
	value = azurerm_storage_account.tfstate.name 
} 
output "storage_container_name" { 
	value = azurerm_storage_container.tfstate.name 
}


after creation add backend.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "624-ec327beb-setting-up-azure-storage-to-be-used-f"
    storage_account_name = "tfstate8h99g"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

terraform init -force-copy # no prompt
```