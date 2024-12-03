resource "random_string" "suffix" {
  length  = 4
  numeric = true
  special = false
  upper   = false
}

resource "azurerm_user_assigned_identity" "k8s_identity" {
  count               = var.deploy_k8s ? 1 : 0
  location            = var.location
  name                = "${local.naming_prefix}-k8suai"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}


# resource "azurerm_role_assignment" "aks_acr_pull" {
#   count                = var.deploy_k8s ? 1 : 0
#   scope                = azurerm_container_registry.acr[0].id
#   role_definition_name = "AcrPull"
#   principal_id         = azurerm_user_assigned_identity.k8s_identity[0].principal_id

#   depends_on = [azurerm_user_assigned_identity.k8s_identity, azurerm_container_registry.acr]
# }

resource "azurerm_role_assignment" "network_contributor" {
  count                = var.deploy_k8s ? 1 : 0
  scope                = var.vnet_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.k8s_identity[0].principal_id

  depends_on = [azurerm_user_assigned_identity.k8s_identity]
}

module "aks" {
  # source = "git::https://github.com/Azure/terraform-azurerm-aks.git?ref=c9174e55c6b5dddf5ddc9e09b739241f72ddbb74"
  source  = "Azure/aks/azurerm"
  version = "9.1.0"
  count   = var.deploy_k8s ? 1 : 0

  # checkov:skip=CKV_AZURE_170: Using free tier for testing purposes
  # checkov:skip=CKV_AZURE_115: Public cluster required for testing purposes
  # checkov:skip=CKV_AZURE_168: Already started max pods via agents_max_pods
  # checkov:skip=CKV_AZURE_127: Enable_host_encryption = true not for Default VM


  ## Building Block Compute 
  location            = var.location
  prefix              = local.naming_prefix
  resource_group_name = var.resource_group_name
  kubernetes_version  = var.k8s_version
  sku_tier            = var.sku_tier
  agents_size         = var.default_node_vm_size
  agents_min_count    = var.auto_scaling_default_node ? var.node_min_count : null
  agents_max_count    = var.auto_scaling_default_node ? var.node_max_count : null
  agents_count        = var.node_count
  agents_max_pods     = var.max_pods
  os_disk_size_gb     = var.os_disk_size_gb

  node_pools = local.node_pools

  automatic_channel_upgrade   = local.aks_config.automatic_channel_upgrade
  temporary_name_for_rotation = local.aks_config.temporary_name_for_rotation

  ## Building Block Container
  # tflint-ignore: terraform_deprecated_interpolation
  # attached_acr_id_map = {
  # "acr_devops" = azurerm_container_registry.acr[0].id
  # }
  log_analytics_workspace_enabled = true

  ## Building Block Networking 
  vnet_subnet_id          = var.vnet_subnet_id
  network_plugin          = local.aks_config.network_plugin
  network_plugin_mode     = local.aks_config.network_plugin_mode
  network_policy          = local.aks_config.network_policy
  ebpf_data_plane = "cilium"
  private_cluster_enabled = false


  ## Building Block Roles
  admin_username                    = var.admin_username
  role_based_access_control_enabled = local.aks_config.role_based_access_control_enabled
  rbac_aad                          = local.aks_config.rbac_aad
  rbac_aad_managed                  = local.aks_config.rbac_aad_managed
  azure_policy_enabled              = local.aks_config.azure_policy_enabled
  rbac_aad_admin_group_object_ids   = var.rbac_aad_admin_group_object_ids
  identity_type                     = "UserAssigned"
  identity_ids                      = [azurerm_user_assigned_identity.k8s_identity[0].id]


  tags = var.tags

  depends_on = [azurerm_role_assignment.network_contributor]
}


 #Todo: Enable ACR via Input Parameter
# resource "azurerm_container_registry" "acr" {
#   name                          = "${var.application}${var.environment}${var.location_short}acr${random_string.suffix.result}"
#   count                         = var.deploy_k8s ? 1 : 0
#   resource_group_name           = var.resource_group_name
#   location                      = var.location
#   sku                           = var.acr_sku
#   admin_enabled                 = var.acr_admin_enabled
#   public_network_access_enabled = true

#   # checkov:skip=CKV_AZURE_233: Geo-replication not supported in Basic SKU
#   # checkov:skip=CKV_AZURE_167: Retention policy not supported in Basic SKU
#   # checkov:skip=CKV_AZURE_164: Trust policy not supported in Basic SKU
#   # checkov:skip=CKV_AZURE_165: Geo-replication not supported in Basic SKU
#   # checkov:skip=CKV_AZURE_166: Quarantine policy not supported in Basic SKU
#   # checkov:skip=CKV_AZURE_163: Vulnerability scanning not supported in Basic SKU
#   ## checkov:skip=CKV_AZURE_139: Public Access is necessary.

#   lifecycle {
#     ignore_changes = [name]
#   }
# }
