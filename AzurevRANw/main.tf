
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
  name                 = var.subnetname
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefix     = "10.0.1.0/24"
}

provider "vra" {
  url           = var.url
  refresh_token = var.refresh_token
}

data "vra_cloud_account_azure" "this" {
  name = var.cloud_account
}

data "vra_region" "this" {
  cloud_account_id = data.vra_cloud_account_azure.this.id
  region           = var.region
}

data "vra_fabric_network" "subnet_1" {
  filter = "name eq '${var.subnet_name_1}'"
}

resource "vra_network_profile" "simple" {
  depends_on = [time_sleep.wait_15_minutes]
  name        = "no-isolation"
  description = "Simple Network Profile with no isolation."
  region_id   = data.vra_region.this.id

  fabric_network_ids = [
    data.vra_fabric_network.subnet_1.id,
  ]

  isolation_type = "NONE"

  tags {
    key   = "foo"
    value = "bar"
  }
}


#Time mgmt
resource "time_sleep" "wait_15_minutes" {
  depends_on = [azurerm_subnet.example]

  create_duration = "15m"
}


