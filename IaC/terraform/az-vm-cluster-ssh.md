```
# providers.tf
terraform {
  required_version = ">=0.12"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# networking.tf
resource "azurerm_resource_group" "comics" {
  name     = "659-8f1c240e-create-a-vm-cluster-in-azure-with-ter"
  location = "centralus"
}

resource "azurerm_virtual_network" "comics" {
  name                = "vnet"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.comics.name
  location            = azurerm_resource_group.comics.location
}

resource "azurerm_subnet" "comics" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.comics.name
  virtual_network_name = azurerm_virtual_network.comics.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "comics" {
  name                = "publicIPForLB"
  resource_group_name = azurerm_resource_group.comics.name
  location            = azurerm_resource_group.comics.location
  allocation_method   = "Static"
}

lbs.tf

resource "azurerm_lb" "comics" {
  name                = "loadBalancer"
  resource_group_name = azurerm_resource_group.comics.name
  location            = azurerm_resource_group.comics.location

  frontend_ip_configuration {
    name                 = "publicIPAddress"
    public_ip_address_id = azurerm_public_ip.comics.id
  }
}

resource "azurerm_lb_backend_address_pool" "comics" {
  loadbalancer_id = azurerm_lb.comics.id
  name            = "BackEndAddressPool"
}

vms.tf

resource "azurerm_network_interface" "comics" {
  count               = 2
  name                = "nic${count.index}"
  location            = azurerm_resource_group.comics.location
  resource_group_name = azurerm_resource_group.comics.name

  ip_configuration {
    name                          = "comicsConfiguration"
    subnet_id                     = azurerm_subnet.comics.id
    private_ip_address_allocation = "dynamic"
  }
}


resource "azurerm_availability_set" "comics" {
  name                         = "avset"
  location                     = azurerm_resource_group.comics.location
  resource_group_name          = azurerm_resource_group.comics.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}
resource "tls_private_key" "comics" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "azurerm_linux_virtual_machine" "comics" {
  count                 = 2
  name                  = "vm${count.index}"
  location              = azurerm_resource_group.comics.location
  availability_set_id   = azurerm_availability_set.comics.id
  resource_group_name   = azurerm_resource_group.comics.name
  network_interface_ids = [element(azurerm_network_interface.comics.*.id, count.index)]
  size               = "Standard_DS1_v2"

  source_image_reference  {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  disable_password_authentication = true
  admin_username = "azureuser"
  computer_name  = "hostname"
  admin_ssh_key {
    username  = "azureuser" # need to use the same user as above
    public_key = tls_private_key.comics.public_key_openssh
  }

  tags = {
    environment = "staging"
  }
}
output "tls_private_key" {
  value     = tls_private_key.comics.private_key_pem
  sensitive = true
}

resource "azurerm_managed_disk" "comics" {
  count                = 2
  name                 = "datadisk_existing_${count.index}"
  location             = azurerm_resource_group.comics.location
  resource_group_name  = azurerm_resource_group.comics.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
}

resource "azurerm_virtual_machine_data_disk_attachment" "comics" {
  count = 2
  managed_disk_id    =  element(azurerm_managed_disk.comics.*.id, count.index)
  virtual_machine_id = element(azurerm_linux_virtual_machine.comics.*.id, count.index)
  lun                = "10"
  caching            = "ReadWrite"
}
```
