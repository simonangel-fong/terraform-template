# main.tf

# ##############################
# Argo CD
# ##############################
resource "helm_release" "this" {
  name       = local.release_name
  repository = local.chart_repository
  chart      = local.chart_name
  version    = var.argocd_version
  namespace  = var.namespace

  create_namespace = true

  values = compact([
    local.default_values,
    var.extra_values,
  ])

  atomic        = false
  wait          = false
  wait_for_jobs = false
  timeout       = 600
}
