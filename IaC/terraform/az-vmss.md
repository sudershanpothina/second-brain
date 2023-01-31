```
# providers.tf
 terraform {

   required_version = ">=0.12"

   required_providers {
     azurerm = {
       source = "hashicorp/azurerm"
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
   name     = "667-836707d0-create-a-vm-scale-set-in-azure-with-t"
   location = "southcentralus"
 }

 resource "random_string" "fqdn" {
 length  = 6
 special = false
 upper   = false
 number  = false
}

resource "azurerm_virtual_network" "comics" {
 name                = "comics-vnet"
 address_space       = ["10.0.0.0/16"]
 location            = var.location
 resource_group_name = azurerm_resource_group.comics.name
 tags                = var.tags
}

resource "azurerm_subnet" "comics" {
 name                 = "comics-subnet"
 resource_group_name  = azurerm_resource_group.comics.name
 virtual_network_name = azurerm_virtual_network.comics.name
 address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "comics" {
 name                         = "comics-public-ip"
 location                     = var.location
 resource_group_name          = azurerm_resource_group.comics.name
 allocation_method            = "Static"
 domain_name_label            = random_string.fqdn.result
 tags                         = var.tags
}

resource "azurerm_lb" "comics" {
 name                = "comics-lb"
 location            = var.location
 resource_group_name = azurerm_resource_group.comics.name

 frontend_ip_configuration {
   name                 = "PublicIPAddress"
   public_ip_address_id = azurerm_public_ip.comics.id
 }

 tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
 loadbalancer_id     = azurerm_lb.comics.id
 name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "comics" {
 resource_group_name = azurerm_resource_group.comics.name
 loadbalancer_id     = azurerm_lb.comics.id
 name                = "ssh-running-probe"
 port                = var.application_port
}

resource "azurerm_lb_rule" "lbnatrule" {
   resource_group_name            = azurerm_resource_group.comics.name
   loadbalancer_id                = azurerm_lb.comics.id
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = var.application_port
   backend_port                   = var.application_port
   backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
   frontend_ip_configuration_name = "PublicIPAddress"
   probe_id                       = azurerm_lb_probe.comics.id
}

# vmss.tf

resource "tls_private_key" "comics" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "azurerm_linux_virtual_machine_scale_set" "comics" {
   name                = "vmscaleset"
   location            = var.location
   resource_group_name = azurerm_resource_group.comics.name
   upgrade_mode = "Manual"
   sku                 = "Standard_DS1_v2"
   instances           = 2
   admin_username      = "adminuser"
   custom_data          = base64encode(file("./web.conf"))
   admin_ssh_key {
      username   = "adminuser"
      public_key = tls_private_key.comics.public_key_openssh
    }

   source_image_reference {
     publisher = "Canonical"
     offer     = "UbuntuServer"
     sku       = "16.04-LTS"
     version   = "latest"
   }    

   os_disk {
     caching           = "ReadWrite"
     storage_account_type  = "Standard_LRS"
   }      

   network_interface  {
     name    = "terraformnetworkprofile"
     primary = true    

     ip_configuration {
       name                                   = "IPConfiguration"
       subnet_id                              = azurerm_subnet.comics.id
       load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
       primary = true
     }
   }    

   tags = var.tags
}

# jumpbox.tf

resource "azurerm_public_ip" "jumpbox" {
  name                         = "jumpbox-public-ip"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.comics.name
  allocation_method            = "Static"
  domain_name_label            = "${random_string.fqdn.result}-ssh"

  tags                         = var.tags
}

resource "azurerm_network_interface" "jumpbox" {
  name                = "jumpbox-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.comics.name

  ip_configuration {
    name                          = "IPConfiguration"
    subnet_id                     = azurerm_subnet.comics.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox.id
  }

  tags = var.tags
}

resource "azurerm_virtual_machine" "jumpbox" {
  name                  = "jumpbox"
  location              = var.location
  resource_group_name   = azurerm_resource_group.comics.name
  network_interface_ids = [azurerm_network_interface.jumpbox.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "jumpbox-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "jumpbox"
    admin_username = var.admin_user
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = var.tags
}

# variables.tf

variable "location" {
   default = "southcentralus"
   description = "Location where resources will be created"
}

variable "tags" {
   description = "Map of the tags to use for the resources that are deployed"
   type        = map(string)
   default = {
      environment = "Staging"
   }
}

variable "application_port" {
   description = "Port that you want to expose to the external load balancer"
   default     = 80
}

variable "admin_user" {
   description = "User name to use as the admin account on the VMs that will be part of the VM scale set"
   default     = "azureuser"
}

variable "admin_password" {
   description = "User name to use as the admin account on the VMs that will be part of the VM scale set"
   default     = "Password123#"
}

# web.conf
#cloud-config
package_upgrade: true
packages:
 - nginx
 - docker

 https://learn.acloud.guru/course/advanced-terraform-with-azure/learn/890af5db-15b3-4d82-9e5d-61e6cf732ec8/86e69ae7-4f18-4ec8-978a-c9587385564b/watch
 
```