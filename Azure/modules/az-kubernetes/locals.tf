locals {
  naming_prefix = "${var.application}-${var.environment}-${var.location_short}"
}

locals {
  aks_config = {
    automatic_channel_upgrade         = "patch"
    temporary_name_for_rotation       = "temp1"
    network_plugin                    = "azure"
    network_plugin_mode               = "overlay" #Required for Cilium   
    network_policy                    = "cilium"      #Cilium not Azure Network Policy 
    ebpf_data_plane                   = "cilium"
    role_based_access_control_enabled = false
    rbac_aad                          = false
    rbac_aad_managed                  = false
    azure_policy_enabled              = true
  }
  node_pools = {
    for name, config in var.node_pools : name => merge(config, {
      #vnet_subnet_id        = data.azurerm_subnet.mgmt_subnet.id
      orchestrator_version  = var.k8s_version
      os_type               = "Linux"
      enable_node_public_ip = false
      priority              = "Regular"
      tags                  = var.tags
    })
  }
  
}