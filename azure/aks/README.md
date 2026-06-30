<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version |
| ------------------------------------------------------------------------ | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.6  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm)       | ~> 4.0  |

## Providers

| Name                                                         | Version |
| ------------------------------------------------------------ | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | 4.79.0  |

## Resources

| Name                                                                                                                                  | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |

## Inputs

| Name                                                                                       | Description                                                             | Type                                                                                                                                                                                                                                                                                                                                                                                                                                     | Default | Required |
| ------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_aks_name"></a> [aks_name](#input_aks_name)                                  | Name of the AKS cluster. Used as both the resource name and dns_prefix. | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                 | n/a     |   yes    |
| <a name="input_location"></a> [location](#input_location)                                  | Azure region for the cluster. Must match the resource group's region.   | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                 | n/a     |   yes    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name) | Name of an existing resource group to deploy the cluster into.          | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                 | n/a     |   yes    |
| <a name="input_default_node_pool"></a> [default_node_pool](#input_default_node_pool)       | Configuration for the default (system) node pool.                       | <pre>object({<br/> name = optional(string, "default")<br/> vm_size = optional(string, "Standard_D2s_v3")<br/> node_count = optional(number, 2)<br/> enable_auto_scaling = optional(bool, false)<br/> min_count = optional(number, null)<br/> max_count = optional(number, null)<br/> vnet_subnet_id = optional(string, null)<br/> os_disk_size_gb = optional(number, 30)<br/> only_critical_addons = optional(bool, false)<br/> })</pre> | `{}`    |    no    |
| <a name="input_network_profile"></a> [network_profile](#input_network_profile)             | Cluster network profile. Set to null to use AzureRM defaults.           | <pre>object({<br/> network_plugin = optional(string, "azure")<br/> network_policy = optional(string, null)<br/> service_cidr = optional(string, null)<br/> dns_service_ip = optional(string, null)<br/> load_balancer_sku = optional(string, "standard")<br/> outbound_type = optional(string, "loadBalancer")<br/> })</pre>                                                                                                             | `null`  |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                              | Tags applied to the cluster.                                            | `map(string)`                                                                                                                                                                                                                                                                                                                                                                                                                            | `{}`    |    no    |

## Outputs

| Name                                                                                                  | Description                                                                                          |
| ----------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| <a name="output_cluster_ca_certificate"></a> [cluster_ca_certificate](#output_cluster_ca_certificate) | Base64-encoded cluster CA certificate from kube_config. Sensitive.                                   |
| <a name="output_cluster_endpoint"></a> [cluster_endpoint](#output_cluster_endpoint)                   | API server endpoint (host) for the cluster, sourced from kube_config.                                |
| <a name="output_cluster_id"></a> [cluster_id](#output_cluster_id)                                     | Resource ID of the AKS cluster.                                                                      |
| <a name="output_cluster_name"></a> [cluster_name](#output_cluster_name)                               | Name of the AKS cluster.                                                                             |
| <a name="output_cluster_version"></a> [cluster_version](#output_cluster_version)                      | Kubernetes version running on the cluster control plane.                                             |
| <a name="output_kube_config_raw"></a> [kube_config_raw](#output_kube_config_raw)                      | Raw kubeconfig for the cluster. Sensitive.                                                           |
| <a name="output_node_resource_group"></a> [node_resource_group](#output_node_resource_group)          | Auto-generated resource group that holds the cluster's node-pool infrastructure (VMSS, NICs, disks). |
| <a name="output_oidc_issuer_url"></a> [oidc_issuer_url](#output_oidc_issuer_url)                      | OIDC issuer URL for workload identity federation.                                                    |

<!-- END_TF_DOCS -->
