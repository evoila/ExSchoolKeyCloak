#!/usr/bin/env bash

# Hauptcluster und Data Source
terraform state rm data.azurerm_kubernetes_cluster.aks
terraform state rm module.aks_gitops.module.aks[0].azurerm_kubernetes_cluster.main

# Alle Kubernetes/Helm-bezogenen Ressourcen
terraform state rm module.gitops_core_platform.helm_release.argocd
terraform state rm module.gitops_core_platform.helm_release.platform_bootstrap
terraform state rm module.gitops_core_platform.kubernetes_secret.argo_cred_template
terraform state rm module.gitops_core_platform.kubernetes_secret.bootstrap_oci
terraform state rm module.gitops_core_platform.kubernetes_secret.platform_config

# Zusätzliche Cluster-bezogene Ressourcen
terraform state rm module.aks_gitops.module.aks[0].null_resource.kubernetes_cluster_name_keeper
terraform state rm module.aks_gitops.module.aks[0].tls_private_key.ssh[0]