# General 

variable "application" {
  description = "The application name (e.g., tsp1, tsp2, tsp3)."
  type        = string
}

variable "environment" {
  description = "The environment (e.g., acc, prod, stg)."
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
}
variable "location_short" {
  description = "The short name of the Azure region."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

# k8s 

variable "deploy_k8s" {
  description = "Steuert, TSP Modul"
  type        = bool
  default     = true
}

variable "node_pools" {
  description = "Map of node pool configurations"
  type = map(object({
    name                = string
    vm_size             = string
    node_count          = number
    os_disk_size_gb     = number
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    max_pods            = number
    vnet_subnet_id      = string
  }))
}


## AKS

variable "resource_group_name" {
  description = "Name of the resource group to deploy the AKS cluster in."
  type        = string
}

variable "os_disk_size_gb" {
  description = "Size of the OS disk for each node in the AKS cluster."
  type        = number
  default     = 60
}
variable "attached_acr_id_map" {
  description = "A map of ACR IDs to attach to the AKS cluster."
  type        = map(string)
  default     = {}
}

variable "vnet_subnet_id" {
  description = "ID of the subnet to deploy the AKS cluster in."
  type        = string
}

variable "rbac_aad_admin_group_object_ids" {
  description = "Object IDs of the Azure AD groups that should have admin access to the AKS cluster."
  type        = list(string)
}

variable "admin_username" {
  description = "User to access the virtual machines of the system (use lower case, no spaces and special characters ex: azureuser)"
  type        = string
}

variable "k8s_version" {
  description = "Version of Kubernetes specified when creating the AKS managed cluster."
  type        = string
  default     = "1.30"
}

variable "default_node_vm_size" {
  description = "Size of the main nodepool VM"
  type        = string
  default     = "Standard_B2s"
}

variable "auto_scaling_default_node" {
  description = "Enables auto-scaling of the main node"
  type        = bool
  default     = true
}

variable "node_count" {
  description = "Number of Cluster Nodes"
  type        = number
  default     = 3
}

variable "node_min_count" {
  description = "Minimum number of nodes in the cluster"
  type        = number
  default     = 1
}

variable "node_max_count" {
  description = "Maximum number of nodes in the cluster"
  type        = number
  default     = 3
}


variable "sku_tier" {
  description = "(Optional) Defines the SLA plan for the availability of system. Valid options are Free or Paid, paid option enables the Uptime SLA feature (see https://docs.microsoft.com/en-us/azure/aks/uptime-sla for more info)"
  type        = string
  default     = "Free"
}


variable "max_pods" {
  description = "Maximum number of pods that can run on each node"
  type        = string
  default     = 50
}


# ACR 

## ACR 

variable "acr_sku" {
  description = "The SKU of the Azure Container Registry (ACR)"
  type        = string
  default     = "Basic"
}

variable "acr_admin_enabled" {
  description = "Specifies whether the admin user is enabled for the Azure Container Registry (ACR)"
  type        = bool
  default     = false
}