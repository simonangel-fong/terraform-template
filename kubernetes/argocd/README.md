<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version |
| ------------------------------------------------------------------------ | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.6  |
| <a name="requirement_helm"></a> [helm](#requirement_helm)                | ~> 2.13 |

## Providers

| Name                                                | Version |
| --------------------------------------------------- | ------- |
| <a name="provider_helm"></a> [helm](#provider_helm) | 2.17.0  |

## Resources

| Name                                                                                                      | Type     |
| --------------------------------------------------------------------------------------------------------- | -------- |
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name                                                                        | Description                                                                                           | Type     | Default    | Required |
| --------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- | -------- | ---------- | :------: |
| <a name="input_argocd_version"></a> [argocd_version](#input_argocd_version) | Argo CD Helm chart version (argo-cd chart from https://argoproj.github.io/argo-helm).                 | `string` | `"9.7.0"`  |    no    |
| <a name="input_extra_values"></a> [extra_values](#input_extra_values)       | Additional Helm values YAML merged on top of the module defaults. Empty string disables the override. | `string` | `""`       |    no    |
| <a name="input_namespace"></a> [namespace](#input_namespace)                | Kubernetes namespace Argo CD is installed into. Created by the chart if it does not exist.            | `string` | `"argocd"` |    no    |

## Outputs

| Name                                                                       | Description                                    |
| -------------------------------------------------------------------------- | ---------------------------------------------- |
| <a name="output_chart_version"></a> [chart_version](#output_chart_version) | Argo CD Helm chart version that was installed. |
| <a name="output_namespace"></a> [namespace](#output_namespace)             | Namespace Argo CD was installed into.          |
| <a name="output_release_name"></a> [release_name](#output_release_name)    | Name of the Helm release.                      |

<!-- END_TF_DOCS -->
