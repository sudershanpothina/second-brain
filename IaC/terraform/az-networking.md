```
resource "azurerm_resource_group" "comics123" {
  name     = "658-b622ba41-creating-network-resources-in-azure-w"
  location = "westus"
}
resource "azurerm_virtual_network" "comics123" {
  name                = "vnet"
  location            = azurerm_resource_group.comics123.location
  resource_group_name = azurerm_resource_group.comics123.name
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "comics123" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.comics123.name
  virtual_network_name = azurerm_virtual_network.comics123.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "comics123" {
  name                = "publicIpForLB"
  resource_group_name = azurerm_resource_group.comics123.name
  location            = azurerm_resource_group.comics123.location
  allocation_method   = "Static"
}

#lb.tf
resource "azurerm_lb" "comics123" {
  name                = "loadBalancer"
  resource_group_name = azurerm_resource_group.comics123.name
  location            = azurerm_resource_group.comics123.location

  frontend_ip_configuration {
    name                 = "publicIPAddress"
    public_ip_address_id = azurerm_public_ip.comics123.id
  }
}
resource "azurerm_lb_backend_address_pool" "comics" {
  loadbalancer_id = azurerm_lb.comics123.id
  name            = "BackendAddressPool"
}
```