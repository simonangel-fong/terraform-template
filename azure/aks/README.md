# azure/aks

AKS cluster with a security-first baseline: SystemAssigned identity, AKS-managed Entra ID (Azure AD) integration with Azure RBAC, local accounts disabled, OIDC + workload identity, and the Azure Policy add-on.

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

## Security defaults

| Setting                     | Default | Notes                                                  |
| --------------------------- | ------- | ------------------------------------------------------ |
| `local_account_disabled`    | `true`  | Auth must go through Entra ID; no static admin kubeconfig. |
| Azure AD / Azure RBAC       | on      | Requires `admin_group_object_ids`.                     |
| `oidc_issuer_enabled`       | `true`  | Required for the `oidc_issuer_url` output.             |
| `workload_identity_enabled` | `true`  | Modern pod identity (replaces pod-identity).           |
| `azure_policy_enabled`      | `true`  | Gatekeeper-based policy add-on.                        |
| `private_cluster_enabled`   | `false` | Opt in via `private_cluster_enabled = true`.           |

## Requirements

- Terraform >= 1.6
- AzureRM provider ~> 4.0
- Resource group already exists
- `azurerm` provider configured by the caller

<!-- BEGIN_TF_DOCS -->
<!-- terraform-docs will populate inputs/outputs tables here -->
<!-- END_TF_DOCS -->
