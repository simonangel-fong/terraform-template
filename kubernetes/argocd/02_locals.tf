locals {
  # ##############################
  # chart
  # ##############################
  chart_repository = "https://argoproj.github.io/argo-helm"
  chart_name       = "argo-cd"
  release_name     = "argocd"

  # ##############################
  # values
  # ##############################
  default_values = yamlencode({
    server = {
      service = {
        type = "ClusterIP"
      }
    }
  })
}
