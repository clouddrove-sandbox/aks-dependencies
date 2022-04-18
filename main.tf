module "resource_group" {
  source  = "clouddrove/resource-group/azure"
  version = "1.0.0"

  environment = "test"
  label_order = ["name", "environment", ]

  name     = "example-resource-group"
  location = "North Europe"
}

module "virtual-network" {
  source              = "clouddrove/virtual-network/azure"
  environment         = "test"
  label_order         = ["name", "environment"]
  name                = "example"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_space       = "10.0.0.0/8"
  subnet_names        = ["subnet1"]
  subnet_prefixes     = ["10.1.0.0/16"]
  enable_ddos_pp      = true
}

module "create-subnet" {
    source = "./modules/subnet"

    subnet_name = var.subnet_name 
    resource_group = module.resource_group.name
    vnet_name = module.virtual-network.name
    subnet_address_prefixes = var.subnet_cidr
}

module "storageaccount" {
    source = "./module/storage"

    resource_group_name = var.resource_group_name
    location = var.location
    storage_account_name = var.storage_account_name
    
}
resource "azurerm_public_ip" "public_ip" {
    provider = azurerm 
    name = "${var.name}-pip"
    location = var.location
    resource_group_name = var.resource_group_name
    allocation_method = "Static"
    sku = "Standard"
    availability_zone  = "No-Zone"
}

resource "azurerm_firewall" "firewall" {
    provider = azurerm
    name = var.firewall_name
    location = var.location
    resource_group_name = var.resource_group_name
    sku_tier = var.sku

    ip_configuration {
        name = "${var.name}-pip"
        subnet_id = module.create-subnet.id 
        public_ip_address_id = azurerm_public_ip.public_ip.id 
    }
}

