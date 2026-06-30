# Azure Kubernetes Service (AKS) - General purpose

[Back](../../README.md)

- [Azure Kubernetes Service (AKS) - General purpose](#azure-kubernetes-service-aks---general-purpose)
  - [Requirements](#requirements)
  - [Usage](#usage)
  - [Reference](#reference)
  - [Requirements](#requirements-1)
  - [Providers](#providers)
  - [Resources](#resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Default](#default)
    - [Security](#security)
    - [Node pool](#node-pool)
    - [Network profile](#network-profile)
  - [Notes](#notes)

---

## Requirements

- Terraform >= 1.6
- AzureRM provider ~> 4.0
- Resource group already exists
- `azurerm` provider configured by the caller
- At least one Entra ID group object ID for `admin_group_object_ids`

---

## Usage

```terraform
module "aks" {
  source = "git::https://github.com/simonangel-fong/terraform-template.git//azure/aks?ref=v1.0.0"

  project_name        = "demo"
  env                 = "dev"
  resource_group_name = "demo-rg"
  location            = "eastus"

  # At least one Entra ID group object ID. Members of these groups get
  # cluster-admin. Required: local accounts are disabled.
  admin_group_object_ids = ["00000000-0000-0000-0000-000000000000"]

  default_node_pool = {
    vm_size    = "Standard_D2s_v3"
    node_count = 2
  }

  tags = {
    owner = "platform-team"
  }
}
```

The cluster name and `dns_prefix` are derived as `"${project_name}-${env}"`.

---

## Reference

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

| Name                                                                                                   | Description                                                                                                                                                    | Type                                                                                                                                                                                                                                                                                                                                                                                                                                     | Default | Required |
| ------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_admin_group_object_ids"></a> [admin_group_object_ids](#input_admin_group_object_ids)    | Entra ID (Azure AD) group object IDs granted cluster-admin via AKS-managed Azure AD integration. At least one is required because local accounts are disabled. | `list(string)`                                                                                                                                                                                                                                                                                                                                                                                                                           | n/a     |   yes    |
| <a name="input_env"></a> [env](#input_env)                                                             | Environment identifier (e.g. dev, staging, prod). Combined with project_name to form the cluster name and dns_prefix.                                          | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                 | n/a     |   yes    |
| <a name="input_location"></a> [location](#input_location)                                              | Azure region for the cluster. Must match the resource group's region.                                                                                          | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                 | n/a     |   yes    |
| <a name="input_project_name"></a> [project_name](#input_project_name)                                  | Short project identifier. Combined with env to form the cluster name and dns_prefix, so it must be DNS-safe.                                                   | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                 | n/a     |   yes    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)             | Name of an existing resource group to deploy the cluster into.                                                                                                 | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                 | n/a     |   yes    |
| <a name="input_default_node_pool"></a> [default_node_pool](#input_default_node_pool)                   | Configuration for the default (system) node pool.                                                                                                              | <pre>object({<br/> name = optional(string, "default")<br/> vm_size = optional(string, "Standard_D2s_v3")<br/> node_count = optional(number, 2)<br/> enable_auto_scaling = optional(bool, false)<br/> min_count = optional(number, null)<br/> max_count = optional(number, null)<br/> vnet_subnet_id = optional(string, null)<br/> os_disk_size_gb = optional(number, 30)<br/> only_critical_addons = optional(bool, false)<br/> })</pre> | `{}`    |    no    |
| <a name="input_network_profile"></a> [network_profile](#input_network_profile)                         | Cluster network profile. Set to null to use AzureRM defaults.                                                                                                  | <pre>object({<br/> network_plugin = optional(string, "azure")<br/> network_policy = optional(string, null)<br/> service_cidr = optional(string, null)<br/> dns_service_ip = optional(string, null)<br/> load_balancer_sku = optional(string, "standard")<br/> outbound_type = optional(string, "loadBalancer")<br/> })</pre>                                                                                                             | `null`  |    no    |
| <a name="input_private_cluster_enabled"></a> [private_cluster_enabled](#input_private_cluster_enabled) | If true, the AKS API server is only reachable from the cluster's VNet. Requires private DNS / jumpbox plumbing on the caller side.                             | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                   | `false` |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                          | Tags applied to the cluster. Merged with module-default tags (Project, Environment, ManagedBy).                                                                | `map(string)`                                                                                                                                                                                                                                                                                                                                                                                                                            | `{}`    |    no    |

## Outputs

| Name                                                                                | Description                                                                                                                                              |
| ----------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <a name="output_cluster_id"></a> [cluster_id](#output_cluster_id)                   | Resource ID of the AKS cluster.                                                                                                                          |
| <a name="output_cluster_name"></a> [cluster_name](#output_cluster_name)             | Name of the AKS cluster.                                                                                                                                 |
| <a name="output_kube_config_raw"></a> [kube_config_raw](#output_kube_config_raw)    | Raw kubeconfig for the cluster. Sensitive.                                                                                                               |
| <a name="output_kubeconfig_cmd"></a> [kubeconfig_cmd](#output_kubeconfig_cmd)       | Azure CLI command to merge the cluster's kubeconfig into the local kubectl context. Uses Entra ID auth (no --admin) because local accounts are disabled. |
| <a name="output_kubelet_identity"></a> [kubelet_identity](#output_kubelet_identity) | Managed identity used by the kubelet (object_id, client_id, user_assigned_identity_id).                                                                  |
| <a name="output_oidc_issuer_url"></a> [oidc_issuer_url](#output_oidc_issuer_url)    | OIDC issuer URL for workload identity federation.                                                                                                        |

<!-- END_TF_DOCS -->

---

## Default

### Security

| Setting                     | Default | Notes                                                      |
| --------------------------- | ------- | ---------------------------------------------------------- |
| `local_account_disabled`    | `true`  | Auth must go through Entra ID; no static admin kubeconfig. |
| Azure AD / Azure RBAC       | on      | Requires `admin_group_object_ids`.                         |
| `oidc_issuer_enabled`       | `true`  | Required for the `oidc_issuer_url` output.                 |
| `workload_identity_enabled` | `true`  | Modern pod identity (replaces pod-identity).               |
| `azure_policy_enabled`      | `true`  | Gatekeeper-based policy add-on.                            |
| `private_cluster_enabled`   | `false` | Opt in via `private_cluster_enabled = true`.               |

---

### Node pool

Object with the following optional attributes:

| Attribute              | Type     | Default             | Notes                                                                  |
| ---------------------- | -------- | ------------------- | ---------------------------------------------------------------------- |
| `name`                 | `string` | `"default"`         | Node pool name.                                                        |
| `vm_size`              | `string` | `"Standard_D2s_v3"` | VM SKU for the pool.                                                   |
| `node_count`           | `number` | `2`                 | Fixed node count. Ignored when `enable_auto_scaling = true`.           |
| `enable_auto_scaling`  | `bool`   | `false`             | When true, `min_count` and `max_count` must both be set.               |
| `min_count`            | `number` | `null`              | Min nodes when autoscaling is enabled.                                 |
| `max_count`            | `number` | `null`              | Max nodes when autoscaling is enabled.                                 |
| `vnet_subnet_id`       | `string` | `null`              | Subnet to place nodes in. Required for Azure CNI in BYO-VNet setups.   |
| `os_disk_size_gb`      | `number` | `30`                | OS disk size for nodes.                                                |
| `only_critical_addons` | `bool`   | `false`             | When true, taints the pool so only system-critical workloads schedule. |

---

### Network profile

Object with the following optional attributes. Set the whole variable to `null` (default) to use AzureRM provider defaults.

| Attribute           | Type     | Default          | Allowed values                                                                      |
| ------------------- | -------- | ---------------- | ----------------------------------------------------------------------------------- |
| `network_plugin`    | `string` | `"azure"`        | `azure`, `kubenet`, `none`                                                          |
| `network_policy`    | `string` | `null`           | e.g. `azure`, `calico`, `cilium`                                                    |
| `service_cidr`      | `string` | `null`           | CIDR for Kubernetes service IPs.                                                    |
| `dns_service_ip`    | `string` | `null`           | DNS service IP inside `service_cidr`.                                               |
| `load_balancer_sku` | `string` | `"standard"`     | `basic`, `standard`                                                                 |
| `outbound_type`     | `string` | `"loadBalancer"` | `loadBalancer`, `userDefinedRouting`, `managedNATGateway`, `userAssignedNATGateway` |

---

## Notes

- Because `local_account_disabled = true`, the `--admin` kubeconfig is unavailable. Members of `admin_group_object_ids` authenticate via Entra ID (`az aks get-credentials` without `--admin`).
- The cluster's `dns_prefix` is globally unique within Azure DNS namespace per region; collisions across environments are possible if `project_name` + `env` are not unique.
