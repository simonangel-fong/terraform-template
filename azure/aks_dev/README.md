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
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | Name of the AKS cluster. Used as both the resource name and dns\_prefix. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region for the cluster. Must match the resource group's region. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of an existing resource group to deploy the cluster into. | `string` | n/a | yes |
| <a name="input_default_node_pool"></a> [default\_node\_pool](#input\_default\_node\_pool) | Configuration for the default (system) node pool. Set either node\_count (fixed size)<br/>or autoscale = { min, max } for autoscaling. They are mutually exclusive. | <pre>object({<br/>    name            = optional(string, "default")<br/>    vm_size         = optional(string, "Standard_D2s_v3")<br/>    node_count      = optional(number, 2)<br/>    os_disk_size_gb = optional(number, 30)<br/>    vnet_subnet_id  = optional(string, null)<br/>    autoscale = optional(object({<br/>      min = number<br/>      max = number<br/>    }), null)<br/>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the cluster. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | Base64-encoded cluster CA certificate from kube\_config. Sensitive. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | API server endpoint (host) for the cluster, sourced from kube\_config. Sensitive. |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Resource ID of the AKS cluster. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the AKS cluster. |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | Kubernetes version running on the cluster control plane. |
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw) | Raw kubeconfig for the cluster. Sensitive. |
| <a name="output_node_resource_group"></a> [node\_resource\_group](#output\_node\_resource\_group) | Auto-generated resource group that holds the cluster's node-pool infrastructure (VMSS, NICs, disks). |
| <a name="output_oidc_issuer_url"></a> [oidc\_issuer\_url](#output\_oidc\_issuer\_url) | OIDC issuer URL for workload identity federation. |
<!-- END_TF_DOCS -->
