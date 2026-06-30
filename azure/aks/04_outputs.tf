# outputs.tf

output "cluster_name" {
  description = "Name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.name
}

output "cluster_id" {
  description = "Resource ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.id
}

output "cluster_version" {
  description = "Kubernetes version running on the cluster control plane."
  value       = azurerm_kubernetes_cluster.this.kubernetes_version
}

output "cluster_endpoint" {
  description = "API server endpoint (host) for the cluster, sourced from kube_config."
  value       = azurerm_kubernetes_cluster.this.kube_config[0].host
}

output "cluster_ca_certificate" {
  description = "Base64-encoded cluster CA certificate from kube_config. Sensitive."
  value       = azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
  sensitive   = true
}

output "kube_config_raw" {
  description = "Raw kubeconfig for the cluster. Sensitive."
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for workload identity federation."
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "node_resource_group" {
  description = "Auto-generated resource group that holds the cluster's node-pool infrastructure (VMSS, NICs, disks)."
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}
