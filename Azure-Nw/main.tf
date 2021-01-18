
provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
#  version = "=2.4.0"

  subscription_id = "927c2711-85d7-46f5-9e65-ff653e1145c1"
  client_id       = "7fbfe5da-2d38-412b-b592-4ebc51103430"
  client_secret   = var.client_secret
  tenant_id       = "b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0"

  features {}

}
# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "France Central"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = "example-networkTFCli1"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}
