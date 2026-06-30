# Azure Kubernetes Service (AKS) - General purpose

[Back](../../README.md)

- [Azure Kubernetes Service (AKS) - General purpose](#azure-kubernetes-service-aks---general-purpose)
  - [Requirements](#requirements)
  - [Usage](#usage)
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

## Inputs

| Name                      | Type           | Required | Default | Description                                                                                                                     |
| ------------------------- | -------------- | :------: | ------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `project_name`            | `string`       |   yes    | -       | Short project identifier. 1-20 chars, lowercase alphanumeric or hyphens (must start/end with alphanumeric). Feeds `dns_prefix`. |
| `env`                     | `string`       |   yes    | -       | Environment identifier (e.g. `dev`, `staging`, `prod`). 1-10 chars, same charset as `project_name`.                             |
| `resource_group_name`     | `string`       |   yes    | -       | Name of an existing resource group to deploy the cluster into.                                                                  |
| `location`                | `string`       |   yes    | -       | Azure region for the cluster. Must match the resource group's region.                                                           |
| `admin_group_object_ids`  | `list(string)` |   yes    | -       | Entra ID group object IDs granted cluster-admin. At least one required (local accounts are disabled).                           |
| `private_cluster_enabled` | `bool`         |    no    | `false` | If true, the API server is only reachable from the cluster's VNet. Requires caller-side DNS plumbing.                           |
| `default_node_pool`       | `object`       |    no    | `{}`    | Default (system) node pool configuration. See [Default node pool](#default-node-pool) below.                                    |
| `network_profile`         | `object`       |    no    | `null`  | Cluster network profile. `null` keeps AzureRM defaults. See [Network profile](#network-profile) below.                          |
| `tags`                    | `map(string)`  |    no    | `{}`    | Tags applied to the cluster. Merged with module-default tags (`Project`, `Environment`, `ManagedBy`).                           |

---

## Outputs

| Name               | Sensitive | Description                                                                                   |
| ------------------ | :-------: | --------------------------------------------------------------------------------------------- |
| `cluster_id`       |    no     | Resource ID of the AKS cluster.                                                               |
| `cluster_name`     |    no     | Name of the AKS cluster.                                                                      |
| `kube_config_raw`  |    yes    | Raw kubeconfig for the cluster.                                                               |
| `kubelet_identity` |    no     | Managed identity used by the kubelet (`object_id`, `client_id`, `user_assigned_identity_id`). |
| `oidc_issuer_url`  |    no     | OIDC issuer URL for workload identity federation.                                             |
| `kubeconfig_cmd`   |    no     | Ready-to-run `az aks get-credentials` command (Entra ID auth, no `--admin`).                  |

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
