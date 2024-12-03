variable "tenant_id" {
  type    = string
  default = "d66ad26e-d003-4d84-8802-a689ccd65d0a"
}

variable "subscription_id" {
  type = string
}

variable "subscription_name" {
  type = string
}

variable "subscription_abbreviation" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "location_abbreviation" {
  type = string
}

# Networking ###################################################################

# variable "firewall_ip" {
# }

variable "vnet_address_space" {
}

variable "nsg_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

variable "app_subnet_address_prefixes" {}
variable "app_subnet_service_endpoints" {
  default = ["Microsoft.KeyVault", "Microsoft.Storage"]
}

# variable "data_subnet_address_prefixes" {}
# variable "data_subnet_service_endpoints" {
#   default = ["Microsoft.KeyVault", "Microsoft.Storage"]
# }


variable "resource_tags_default" {
  type        = map(string)
  description = "A map of Tags that will be applied to Azure resources, e.g. 'project' or 'cost-center'."
}



# AKS Config 

## AKS

variable "os_disk_size_gb" {
  description = "Size of the OS disk for each node in the AKS cluster."
  type        = number
  default     = 60
}

variable "k8s_version" {
  description = "Version of Kubernetes specified when creating the AKS managed cluster."
  type        = string
  default     = "1.22.11"
}

variable "default_node_vm_size" {
  description = "Size of the main nodepool VM"
  type        = string
  default     = "Standard_E8as_v4"
}

variable "auto_scaling_default_node" {
  description = "Enables auto-scaling of the main node"
  type        = bool
  default     = true
}

variable "node_count" {
  description = "Number of Cluster Nodes"
  type        = number
  default     = 1
}

variable "node_min_count" {
  description = "Minimum number of nodes in the cluster"
  type        = number
  default     = 1
}

variable "node_max_count" {
  description = "Maximum number of nodes in the cluster"
  type        = number
  default     = 10
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

variable "admin_group_name" {
  description = "Name of the Azure AD group that should have admin access to the AKS cluster"
  type        = string
  default     = ""
}
