output "aks_name" {
  value       = module.aks[0].aks_name
  description = "The `azurerm_kubernetes_cluster`'s name."
}

output "aks_id" {
  value       = module.aks[0].aks_id
  description = "The `azurerm_kubernetes_cluster`'s id."
}

output "host" {
  description = "The Kubernetes cluster server host"
  value       = try(module.aks[0].host, "")
  sensitive   = true
}

output "client_key" {
  description = "Base64 encoded private key used by clients to authenticate to the Kubernetes cluster"
  value       = try(module.aks[0].client_key, "")
  sensitive   = true
}

output "client_certificate" {
  description = "Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster"
  value       = try(module.aks[0].client_certificate, "")
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster"
  value       = try(module.aks[0].cluster_ca_certificate, "")
  sensitive   = true
}

output "kube_config" {
  description = "Raw Kubernetes config to be used by kubectl and other compatible tools"
  value       = try(module.aks[0].kube_config, "")
  sensitive   = true
}