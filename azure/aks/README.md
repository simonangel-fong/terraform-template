<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.79.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group_object_ids"></a> [admin\_group\_object\_ids](#input\_admin\_group\_object\_ids) | Entra ID (Azure AD) group object IDs granted cluster-admin via AKS-managed Azure AD integration. At least one is required because local accounts are disabled. | `list(string)` | n/a | yes |
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | Name of the AKS cluster. Used as both the resource name and dns\_prefix. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region for the cluster. Must match the resource group's region. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of an existing resource group to deploy the cluster into. | `string` | n/a | yes |
| <a name="input_default_node_pool"></a> [default\_node\_pool](#input\_default\_node\_pool) | Configuration for the default (system) node pool. | <pre>object({<br/>    name                 = optional(string, "default")<br/>    vm_size              = optional(string, "Standard_D2s_v3")<br/>    node_count           = optional(number, 2)<br/>    enable_auto_scaling  = optional(bool, false)<br/>    min_count            = optional(number, null)<br/>    max_count            = optional(number, null)<br/>    vnet_subnet_id       = optional(string, null)<br/>    os_disk_size_gb      = optional(number, 30)<br/>    only_critical_addons = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_network_profile"></a> [network\_profile](#input\_network\_profile) | Cluster network profile. Set to null to use AzureRM defaults. | <pre>object({<br/>    network_plugin    = optional(string, "azure")<br/>    network_policy    = optional(string, null)<br/>    service_cidr      = optional(string, null)<br/>    dns_service_ip    = optional(string, null)<br/>    load_balancer_sku = optional(string, "standard")<br/>    outbound_type     = optional(string, "loadBalancer")<br/>  })</pre> | `null` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | If true, the AKS API server is only reachable from the cluster's VNet. Requires private DNS / jumpbox plumbing on the caller side. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the cluster. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Resource ID of the AKS cluster. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the AKS cluster. |
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw) | Raw kubeconfig for the cluster. Sensitive. |
| <a name="output_kubeconfig_cmd"></a> [kubeconfig\_cmd](#output\_kubeconfig\_cmd) | Azure CLI command to merge the cluster's kubeconfig into the local kubectl context. Uses Entra ID auth (no --admin) because local accounts are disabled. |
| <a name="output_kubelet_identity"></a> [kubelet\_identity](#output\_kubelet\_identity) | Managed identity used by the kubelet (object\_id, client\_id, user\_assigned\_identity\_id). |
| <a name="output_oidc_issuer_url"></a> [oidc\_issuer\_url](#output\_oidc\_issuer\_url) | OIDC issuer URL for workload identity federation. |
<!-- END_TF_DOCS -->
