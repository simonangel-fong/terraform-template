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
# Node Pool
# ##############################
variable "default_node_pool" {
  description = <<-EOT
    Configuration for the default (system) node pool. Set either node_count (fixed size)
    or autoscale = { min, max } for autoscaling. They are mutually exclusive.
  EOT
  type = object({
    name            = optional(string, "default")
    vm_size         = optional(string, "Standard_D2s_v3")
    node_count      = optional(number, 2)
    os_disk_size_gb = optional(number, 30)
    vnet_subnet_id  = optional(string, null)
    autoscale = optional(object({
      min = number
      max = number
    }), null)
  })
  default = {}

  validation {
    condition     = try(var.default_node_pool.autoscale.min <= var.default_node_pool.autoscale.max, true)
    error_message = "default_node_pool.autoscale.min must be <= autoscale.max."
  }
}

variable "tags" {
  description = "Tags applied to the cluster."
  type        = map(string)
  default     = {}
}
