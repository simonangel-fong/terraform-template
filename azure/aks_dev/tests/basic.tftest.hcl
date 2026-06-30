# Plan-only tests. The AzureRM provider is mocked so this runs in CI without
# any Azure credentials. For tests that need real apply behavior, write a
# separate *.tftest.hcl that uses the real provider and run it locally.

mock_provider "azurerm" {}

variables {
  aks_name            = "test-aks-dev"
  resource_group_name = "test-rg"
  location            = "eastus"
}

run "defaults" {
  command = plan

  assert {
    condition     = azurerm_kubernetes_cluster.this.name == "test-aks-dev"
    error_message = "Cluster name should match var.aks_name."
  }

  assert {
    condition     = azurerm_kubernetes_cluster.this.dns_prefix == "test-aks-dev"
    error_message = "dns_prefix should match var.aks_name."
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
    condition     = azurerm_kubernetes_cluster.this.oidc_issuer_enabled == true
    error_message = "oidc_issuer_enabled should be true by default."
  }

  assert {
    condition     = azurerm_kubernetes_cluster.this.workload_identity_enabled == true
    error_message = "workload_identity_enabled should be true by default."
  }
}
