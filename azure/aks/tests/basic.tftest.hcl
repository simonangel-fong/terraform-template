# Test locally with a real subscription:
#   az login
#   $env:ARM_SUBSCRIPTION_ID = "<your-sub-id>"
#   terraform test

variables {
  project_name           = "test-aks"
  env                    = "dev"
  resource_group_name    = "test-rg"
  location               = "eastus"
  admin_group_object_ids = ["00000000-0000-0000-0000-000000000000"]
}

provider "azurerm" {
  features {}
}

run "defaults" {
  command = plan

  assert {
    condition     = azurerm_kubernetes_cluster.this.name == "test-aks-dev"
    error_message = "Cluster name should be '<project_name>-<env>'."
  }

  assert {
    condition     = azurerm_kubernetes_cluster.this.dns_prefix == "test-aks-dev"
    error_message = "dns_prefix should default to '<project_name>-<env>'."
  }

  assert {
    condition     = azurerm_kubernetes_cluster.this.default_node_pool[0].name == "default"
    error_message = "Default node pool name should default to 'default'."
  }

  assert {
    condition     = azurerm_kubernetes_cluster.this.default_node_pool[0].vm_size == "Standard_D2s_v3"
    error_message = "Default node pool vm_size should default to 'Standard_D2s_v3'."
  }

  assert {
    condition     = azurerm_kubernetes_cluster.this.identity[0].type == "SystemAssigned"
    error_message = "Cluster identity should default to SystemAssigned."
  }

  assert {
    condition     = azurerm_kubernetes_cluster.this.local_account_disabled == true
    error_message = "local_account_disabled should be true by default."
  }

  assert {
    condition     = azurerm_kubernetes_cluster.this.oidc_issuer_enabled == true
    error_message = "oidc_issuer_enabled should be true by default."
  }

  assert {
    condition     = azurerm_kubernetes_cluster.this.workload_identity_enabled == true
    error_message = "workload_identity_enabled should be true by default."
  }

  assert {
    condition     = azurerm_kubernetes_cluster.this.azure_active_directory_role_based_access_control[0].azure_rbac_enabled == true
    error_message = "Azure RBAC should be enabled by default."
  }
}
