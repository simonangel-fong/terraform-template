# Test locally with a real subscription:
#   az login
#   export ARM_SUBSCRIPTION_ID=<your-sub-id>
#   terraform test

variables {
  name                = "test-aks"
  env                 = "dev"
  location            = "eastus"
  resource_group_name = "test-rg"
}

run "defaults" {
  command = plan

  assert {
    condition     = azurerm_kubernetes_cluster.this.name == "test-aks-dev"
    error_message = "Cluster name did not match input."
  }

  assert {
    condition     = azurerm_kubernetes_cluster.this.dns_prefix == "test-aks-dev"
    error_message = "dns_prefix should default to var.name."
  }
}

