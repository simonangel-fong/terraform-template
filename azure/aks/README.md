# azure/aks

AKS cluster with system-assigned managed identity, a default node pool, and an optional Log Analytics workspace + OMS agent.

## Usage

```hcl
module "aks" {
  source = "git::https://github.com/simonangel-fong/terraform-template.git//azure/aks?ref=v1.0.0"

  name                = "demo-aks"
  location            = "eastus"
  resource_group_name = "demo-rg"
  kubernetes_version  = "1.30.0"

  default_node_pool = {
    vm_size    = "Standard_D2s_v3"
    node_count = 2
  }

  enable_log_analytics = true

  tags = {
    environment = "demo"
  }
}
```

## Requirements

- Terraform >= 1.6
- AzureRM provider ~> 4.0
- Resource group already exists
- `azurerm` provider configured by the caller

<!-- BEGIN_TF_DOCS -->
<!-- terraform-docs will populate inputs/outputs tables here -->
<!-- END_TF_DOCS -->
