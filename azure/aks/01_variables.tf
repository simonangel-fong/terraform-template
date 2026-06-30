# variables.tf

# ##############################
# Metadata
# ##############################
variable "aks_name" {
  description = "Name of the AKS cluster. Used as both the resource name and dns_prefix."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.aks_name)) && length(var.aks_name) <= 63
    error_message = "aks_name must be 1-63 chars, lowercase alphanumeric or hyphens, and must start and end with an alphanumeric."
  }
}

variable "resource_group_name" {
  description = "Name of an existing resource group to deploy the cluster into."
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "resource_group_name must not be empty."
  }
}

variable "location" {
  description = "Azure region for the cluster. Must match the resource group's region."
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "location must not be empty."
  }
}

# ##############################
# Security / Identity
# ##############################
variable "admin_group_object_ids" {
  description = "Entra ID (Azure AD) group object IDs granted cluster-admin via AKS-managed Azure AD integration. At least one is required because local accounts are disabled."
  type        = list(string)

  validation {
    condition     = length(var.admin_group_object_ids) > 0
    error_message = "admin_group_object_ids must contain at least one Entra ID group object ID; local accounts are disabled so there is no fallback."
  }
}

variable "private_cluster_enabled" {
  description = "If true, the AKS API server is only reachable from the cluster's VNet. Requires private DNS / jumpbox plumbing on the caller side."
  type        = bool
  default     = false
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
  description = "Tags applied to the cluster."
  type        = map(string)
  default     = {}
}
