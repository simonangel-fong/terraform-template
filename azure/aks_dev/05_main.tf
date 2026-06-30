# main.tf

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.aks_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  kubernetes_version = local.kubernetes_version

  # ##############################
  # Node Pool
  # ##############################
  default_node_pool {
    name                 = var.default_node_pool.name
    vm_size              = var.default_node_pool.vm_size
    os_disk_size_gb      = var.default_node_pool.os_disk_size_gb
    vnet_subnet_id       = var.default_node_pool.vnet_subnet_id
    node_count           = var.default_node_pool.autoscale == null ? var.default_node_pool.node_count : null
    auto_scaling_enabled = var.default_node_pool.autoscale != null
    min_count            = try(var.default_node_pool.autoscale.min, null)
    max_count            = try(var.default_node_pool.autoscale.max, null)
  }

  # ####################
  # identity
  # ####################
  identity {
    type = "SystemAssigned"
  }
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # ##############################
  # Network
  # ##############################
  dns_prefix = var.aks_name
}
