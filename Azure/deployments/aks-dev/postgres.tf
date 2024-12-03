# Namespace erstellen
resource "kubernetes_namespace" "keycloak" {
  depends_on = [module.aks]
  
  metadata {
    name = "keycloak"
    
    labels = {
      environment = "prod"
      app         = "keycloak"
    }
  }
}


# Storage Class für PostgreSQL
resource "kubernetes_storage_class" "postgres_premium" {
  depends_on = [module.aks]
  
  metadata {
    name = "postgres-premium"
  }

  storage_provisioner = "kubernetes.io/azure-disk"
  reclaim_policy     = "Retain"
  parameters = {
    storageaccounttype = "Premium_LRS"
    kind               = "Managed"
  }
}

# PVC für PostgreSQL
resource "kubernetes_persistent_volume_claim" "postgres" {
  depends_on = [kubernetes_storage_class.postgres_premium]
  
  metadata {
    name      = "postgres-data"
    namespace = "keycloak"
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class.postgres_premium.metadata[0].name

    resources {
      requests = {
        storage = "32Gi"
      }
    }
  }
}