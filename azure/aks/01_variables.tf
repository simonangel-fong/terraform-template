# variables.tf

# ##############################
# Metadata
# ##############################
variable "project_name" {
  description = ""
  type        = string
}

variable "env" {
  description = ""
  type        = string
}

variable "resource_group_name" {
  description = "Name of an existing resource group to deploy the cluster into."
  type        = string
}

# ##############################
# Node Pool
# ##############################
variable "default_node_pool" {
  description = "Configuration for the default (system) node pool."
  type = object({
    name                 = optional(string, "default")
    vm_size              = optional(string, "Standard_D2s_v3")
    node_count           = optional(number, 2)
    enable_auto_scaling  = optional(bool, false)
    min_count            = optional(number, null)
    max_count            = optional(number, null)
    vnet_subnet_id       = optional(string, null)
    os_disk_size_gb      = optional(number, 30)
    only_critical_addons = optional(bool, false)
  })
  default = {}
}

variable "network_profile" {
  description = "Cluster network profile. Set to null to use AzureRM defaults."
  type = object({
    network_plugin    = optional(string, "azure")
    network_policy    = optional(string, null)
    service_cidr      = optional(string, null)
    dns_service_ip    = optional(string, null)
    load_balancer_sku = optional(string, "standard")
    outbound_type     = optional(string, "loadBalancer")
  })
  default = null

  validation {
    condition = var.network_profile == null || contains(
      ["azure", "kubenet", "none"],
      coalesce(try(var.network_profile.network_plugin, null), "azure")
    )
    error_message = "network_profile.network_plugin must be one of: azure, kubenet, none."
  }

  validation {
    condition = var.network_profile == null || contains(
      ["basic", "standard"],
      coalesce(try(var.network_profile.load_balancer_sku, null), "standard")
    )
    error_message = "network_profile.load_balancer_sku must be one of: basic, standard."
  }

  validation {
    condition = var.network_profile == null || contains(
      ["loadBalancer", "userDefinedRouting", "managedNATGateway", "userAssignedNATGateway"],
      coalesce(try(var.network_profile.outbound_type, null), "loadBalancer")
    )
    error_message = "network_profile.outbound_type must be one of: loadBalancer, userDefinedRouting, managedNATGateway, userAssignedNATGateway."
  }
}

variable "tags" {
  description = "Tags applied to all resources created by this module."
  type        = map(string)
  default     = {}
}
