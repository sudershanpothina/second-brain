provider "azurerm" {
  features {}

  skip_provider_registration = true
}

resource "azurerm_service_plan" "svcplan" {
  name                = "newweb-appserviceplan"
  location            = "eastus"
  resource_group_name = "1-5e8b666c-playground-sandbox"
  os_type             = "Linux"
  sku_name            = "S1"

resource "azurerm_linux_web_app" "appsvc" {
  name                = "custom-tf-webapp-for-thestudent1"
  resource_group_name = "1-5e8b666c-playground-sandbox"
  location            = "eastus"
  service_plan_id     = azurerm_service_plan.svcplan.id

  site_config {}
}