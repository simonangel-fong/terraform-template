# <provider_name> - <module_name>

[Back](../../README.md)

<catalog>

---

## Requirements

List the required Terraform version, provider versions, and any prerequisites (e.g., existing resource groups, service principals, enabled APIs).

---

## Usage

Minimal HCL `module "this" { source = "..." }` usage block.

Example:

```terraform
module "aks" {
  source = "git::https://github.com/simonangel-fong/terraform-template.git//azure/aks?ref=v1.0.0"

  project_name        = "demo"
  env                 = "dev"
  resource_group_name = "demo-rg"
  location            = "eastus"

  # At least one Entra ID group object ID. Members of these groups receive
  # cluster-admin access. Required because local accounts are disabled.
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

---

## Inputs

A table listing all input variables.

| Name | Type | Required | Default | Description |

---

## Outputs

A table listing all outputs.

| Name | Sensitive | Description |

---
