

az login --service-principal -u xxxxxxxxxxxxxxxx -p xxxxxxxxxxxxxxxxxx --tenant xxxxxxxxxx
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "xxxxxxxxxxxxx", 
    "id": "xxxxxxxxxxxxxxxxxxxxxxx", # subscription id
    "isDefault": true,
    "managedByTenants": [],
    "name": "P2-Real Hands-On Labs",
    "state": "Enabled",
    "tenantId": "xxxxxxxxxxxxxxxxxx", # tenant id
    "user": {
      "name": "xxxxxxxxxxxxxxxxxxx",
      "type": "servicePrincipal"
    }
  }
]

export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "BatmanInc"
  address_space       = ["10.0.0.0/16"]
  location            = "Central US"
  resource_group_name = "1-5e8b666c-playground-sandbox"
      # Create Tag
    tags = {
        Environment = "Terraform Getting Started"
        Team        = "Batman"
    }
}

resource "azurerm_subnet" "subnet" {
    name                 = "Robins"
    resource_group_name = "1-5e8b666c-playground-sandbox"
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = ["10.0.1.0/24"]
}


variables.tf

variable "azurerm_subnet_name" {}

terraform.tfvars
azurerm_subnet_name = "BoyWonder"

resource "azurerm_subnet" "subnet" {
    name                 = var.azurerm_subnet_name
    resource_group_name = "1-5e8b666c-playground-sandbox"
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = ["10.0.1.0/24"]
}


output "azurerm_virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
}

output "azurerm_subnet_name" {
  value = azurerm_subnet.subnet.name
}

terraform apply # shows the output at the end
terraform output # show the output


storage backend - blob

![](https://i.imgur.com/BfiWsy9.png)


create resource group

```
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "rg" {
	name = "TestRG"
	location = "eastus"
	tags = {
		environment = "Terraform"
		username = "blah"
	}
}
```

recovery vault

```
resource "azurerm_recovery_services_vault" "vault" {
	name = "blahvaultrecovery"
	location = "eastus"
	resource_group_name = "TestRg"
	sku = Standard
}
```

storage account

```
resource "azurerm_storage_account" "example" {
	name = "foostorageaccout"
	resource_group_name = "TestRG"
	location = "eastus"
	account_tier = "Standard"
	account_replication_type = "LRS"
}
resource "azurerm_storage_share" "example" {
	name = "fooshare"
	storage_account_name = azurerm_storage_account.example.name
	quota = 50
}

resource "azurerm_storage_container" "example" {
	name = "foocontainer"
	storage_account_name = azurerm_storage_account.example.name
	container_access_type = "private"
}
```

```

```
```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.93.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}
resource "azurerm_storage_account" "lab" {
  name                     = "sdrshnrckssa0001"
  resource_group_name      = "156-ee88cd08-deploy-an-azure-storage-account-with"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
 network_rules {
    default_action             = "Deny"
    ip_rules                   = ["100.0.0.1"]
    #virtual_network_subnet_ids = [azurerm_subnet.example.id]
  }
  tags = {
    environment = "Terraform Storage"
    CreatedBy   = "Admin"
  }
}

resource "azurerm_storage_container" "lab" {
  name                  = "blobcontainer4lab"
  storage_account_name  = azurerm_storage_account.lab.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "lab" {
  name                   = "TerraformBlob"
  storage_account_name   = azurerm_storage_account.lab.name
  storage_container_name = azurerm_storage_container.lab.name
  type                   = "Block"
}
resource "azurerm_storage_share" "lab" {
  name                 = "terraformshare"  
  storage_account_name = azurerm_storage_account.lab.name
  quota                = 50
}
```

Vnet, subnet and NSG - (good idea to keep nsg in separate files)
```
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "= 2.99"
    }
  }
}

provider "azurerm" {
  features {}

  skip_provider_registration = true
}

# Create virtual network
resource "azurerm_virtual_network" "tfnet" {
    name                = "LabVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = "Enter Resource Group Name"

    tags = {
        environment = "Terraform Networking"
    }
}

# Create subnet
resource "azurerm_subnet" "tfsubnet" {
    name                 = "LabSubnet"
    resource_group_name = azurerm_virtual_network.tfnet.resource_group_name
    virtual_network_name = azurerm_virtual_network.TFNet.name
    address_prefixes       = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "tfsubnet2" {
    name                 = "LabSubnet2"
    resource_group_name = azurerm_virtual_network.tfnet.resource_group_name
    virtual_network_name = azurerm_virtual_network.TFNet.name
    address_prefixes       = ["10.0.2.0/24"]
}
```

NSG and rules

```
resource "azurerm_network_security_group" "nsg" {
  name                = "LabNSG"
  location            = "East US"
  resource_group_name = "Enter resource group name"
}

resource "azurerm_network_security_rule" "example1" {
  name                        = "Web80"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "80"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "Enter Resource group name"
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "example2" {
  name                        = "Web8080"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "8080"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "Enter Resource group name"
  network_security_group_name = azurerm_network_security_group.nsg.name
}

  resource "azurerm_network_security_rule" "example4" {
  name                        = "SSH"
  priority                    = 1100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "Enter Resource group name"
  network_security_group_name = azurerm_network_security_group.nsg.name
}

  resource "azurerm_network_security_rule" "example3" {
  name                        = "Web80Out"
  priority                    = 1000
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "80"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "Enter Resource group name"
  network_security_group_name = azurerm_network_security_group.nsg.name
}
```