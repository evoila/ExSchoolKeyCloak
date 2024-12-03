terraform {
  backend "azurerm" {
    subscription_id      = "cdef9e8b-101e-47c7-82ea-40b8dd5ad886"
    resource_group_name  = "agitops-tfbootstrap"
    storage_account_name = "agitopsbackendsa"
    container_name       = "tf-state-level2"
    key                  = "exschool-aks-dev.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.106"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}
# provider "azurerm" {
#   alias           = "Connectivity"
#   subscription_id = "b1dc91e6-fac3-4435-9189-41acb68d6134" # id of the Connectivity subscription 
#   features {}
# }

# provider "azurerm" {
#   alias           = "Identity"
#   subscription_id = "0a46a099-68ca-4c77-8c5b-75f3d6cfb11f" # id of the Identity Global subscription 
#   features {}
# }


