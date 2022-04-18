resource "azurerm_subnet" "create-subnet" {
  provider = name
  name = var.subnet_name
  resource_group_name = var.resource_group_name
  virtual_network_name = var.vnet_name 
  address_prefix = var.subnet_address_prefixes
  service_endpoints = []
  enforce_private_link_service_network_policies = true 
}