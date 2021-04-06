
provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=2.4.0"

  features {}

}
# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = var.rgname
  location = "France Central"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = var.nwname
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

# Create a virtual subnet within the virtual nw
resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefix     = "10.0.1.0/24"
}
