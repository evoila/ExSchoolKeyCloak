# AKS (Azure Kubernetes Services) resources for GitOps deployment

locals {
  rbac_aad_admin_group_object_ids = [] #"e177f1be-3a07-4129-b3de-d4bdce03f5c1" #ToDo: request separate group via ServiceDesk
}

# Base resource group

resource "azurerm_resource_group" "rg_aks" {
  name     = replace("rg-gitopsaks-${local.env}-${var.location_abbreviation}", "--", "-")
  location = var.location
  tags     = var.resource_tags_default
}



# Zones for our AKS
resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
  depends_on      = [module.vnet]
}

module "aks" {
  source  = "../../modules/az-kubernetes"

  resource_group_name = azurerm_resource_group.rg_aks.name
  location            = azurerm_resource_group.rg_aks.location
  location_short      = var.location_abbreviation
  application         = "gitops"
  environment         = "mgmt"

  vnet_subnet_id                  = module.app_subnet.subnet_id
  rbac_aad_admin_group_object_ids = local.rbac_aad_admin_group_object_ids
  admin_username                  = "azureadmin"

  node_pools = {
    keycloak = {
      name                = "keycloak"
      vm_size             = "Standard_B2ms" 
      node_count          = 1
      os_disk_size_gb     = 128
      enable_auto_scaling = false
      min_count           = null
      max_count           = null
      max_pods            = 110
      vnet_subnet_id      = module.app_subnet.subnet_id
    }
  }
  
  ## Node pool configuration
  default_node_vm_size      = var.default_node_vm_size
  auto_scaling_default_node = var.auto_scaling_default_node
  node_count                = var.node_count
  node_min_count            = var.node_min_count
  node_max_count            = var.node_max_count
  max_pods                  = var.max_pods
  sku_tier                        = var.sku_tier
  k8s_version                     = var.k8s_version
  os_disk_size_gb                 = var.os_disk_size_gb

  #Todo: Enabled Input + Output
  acr_admin_enabled = false
  acr_sku = "Standard" #Basic?

  tags                = var.resource_tags_default
  depends_on = [time_sleep.wait_30_seconds]
}


