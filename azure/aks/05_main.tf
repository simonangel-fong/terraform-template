# main.tf

# ##############################
# Resource Group
# ##############################
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = local.common_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  tags                = merge(var.tags, local.default_tags)
  kubernetes_version  = local.kubernetes_version

  # ##############################
  # Network
  # ##############################
  dns_prefix = local.common_name
  dynamic "network_profile" {
    for_each = var.network_profile == null ? [] : [var.network_profile]
    content {
      network_plugin    = network_profile.value.network_plugin
      network_policy    = network_profile.value.network_policy
      service_cidr      = network_profile.value.service_cidr
      dns_service_ip    = network_profile.value.dns_service_ip
      load_balancer_sku = network_profile.value.load_balancer_sku
      outbound_type     = network_profile.value.outbound_type
    }
  }

  # ##############################
  # Node Pool
  # ##############################
  default_node_pool {
    name                         = var.default_node_pool.name
    vm_size                      = var.default_node_pool.vm_size
    node_count                   = var.default_node_pool.enable_auto_scaling ? null : var.default_node_pool.node_count
    auto_scaling_enabled         = var.default_node_pool.enable_auto_scaling
    min_count                    = var.default_node_pool.enable_auto_scaling ? var.default_node_pool.min_count : null
    max_count                    = var.default_node_pool.enable_auto_scaling ? var.default_node_pool.max_count : null
    vnet_subnet_id               = var.default_node_pool.vnet_subnet_id
    os_disk_size_gb              = var.default_node_pool.os_disk_size_gb
    only_critical_addons_enabled = var.default_node_pool.only_critical_addons
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    precondition {
      condition = !var.default_node_pool.enable_auto_scaling || (
        var.default_node_pool.min_count != null && var.default_node_pool.max_count != null
      )
      error_message = "When default_node_pool.enable_auto_scaling is true, both min_count and max_count must be set."
    }
  }
}
