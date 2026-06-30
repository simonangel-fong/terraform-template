# variables.tf

# ##############################
# Chart
# ##############################
variable "argocd_version" {
  description = "Argo CD Helm chart version (argo-cd chart from https://argoproj.github.io/argo-helm)."
  type        = string
  default     = "9.7.0"

  validation {
    condition     = length(var.argocd_version) > 0
    error_message = "argocd_version must not be empty."
  }
}

# ##############################
# Install target
# ##############################
variable "namespace" {
  description = "Kubernetes namespace Argo CD is installed into. Created by the chart if it does not exist."
  type        = string
  default     = "argocd"

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.namespace)) && length(var.namespace) <= 63
    error_message = "namespace must be 1-63 chars, lowercase alphanumeric or hyphens, and must start and end with an alphanumeric (DNS-1123 label)."
  }
}

# ##############################
# Overrides
# ##############################
variable "extra_values" {
  description = "Additional Helm values YAML merged on top of the module defaults. Empty string disables the override."
  type        = string
  default     = ""
}
