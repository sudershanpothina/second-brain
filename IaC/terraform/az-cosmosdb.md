```
# providers.tf
 terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# cosmosdb.tf

resource "azurerm_resource_group" "super-vote" {
  name     = "<RESOURCE_GROUP_NAME>"
  location = "<RESOURCE_GROUP_NAME>"
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}


resource "azurerm_resource_group" "super-vote" {
  name     = "661-29a31002-create-a-cosmosdb-instance-in-azure-w"
  location = "eastus"
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}
resource "azurerm_cosmosdb_account" "super-vote" {
  name                = "tfex-cosmos-db-${random_integer.ri.result}"
  location            = azurerm_resource_group.super-vote.location
  resource_group_name = azurerm_resource_group.super-vote.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200   
  }

  geo_location {
    location          = "eastus"
    failover_priority = 0
  }
} 

resource "azurerm_container_group" "super-vote" {
  name                = "super-vote"
  location            = azurerm_resource_group.super-vote.location
  resource_group_name = azurerm_resource_group.super-vote.name
  ip_address_type     = "public"
  dns_name_label      = "super-vote"
  os_type             = "linux"

  container {
    name   = "super-vote"
    image  = "mcr.microsoft.com/azuredocs/azure-vote-front:cosmosdb"
    cpu    = "0.5"
    memory = "1.5"
    ports {
      port     = 80
      protocol = "TCP"
    }

    secure_environment_variables = {
      "COSMOS_DB_ENDPOINT"  = azurerm_cosmosdb_account.super-vote.endpoint
      "COSMOS_DB_MASTERKEY" = azurerm_cosmosdb_account.super-vote.primary_master_key
      "TITLE"               = "Best Superhero!"
      "VOTE1VALUE"          = "Batman"
      "VOTE2VALUE"          = "Superman"
    }
  }
}
```