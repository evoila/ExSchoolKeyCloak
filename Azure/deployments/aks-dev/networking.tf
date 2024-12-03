# Networking ###################################################################

resource "azurerm_resource_group" "rg_networking" {
  name     = replace("rg-networking-${local.env}-${var.location_abbreviation}", "--", "-")
  location = var.location
  tags     = var.resource_tags_default
}


# Virtual Network using Claranet module
module "vnet" {
  source  = "claranet/vnet/azurerm"
  version = "7.0.0"

  environment    = var.environment
  location       = azurerm_resource_group.rg_networking.location
  location_short = var.location_abbreviation
  client_name    = "aproject"
  stack          = "networking"

  resource_group_name = azurerm_resource_group.rg_networking.name
  vnet_cidr           = var.vnet_address_space

  custom_vnet_name = "ass-${var.subscription_abbreviation}-vnet-01"


  extra_tags = var.resource_tags_default
}


# Subnet using Claranet module
module "app_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "7.0.0"

  environment    = var.environment
  location_short = var.location_abbreviation
  client_name    = "aproject"
  stack          = "app"

  resource_group_name  = azurerm_resource_group.rg_networking.name
  virtual_network_name = module.vnet.virtual_network_name

  subnet_cidr_list = var.app_subnet_address_prefixes

  service_endpoints = var.app_subnet_service_endpoints

}


