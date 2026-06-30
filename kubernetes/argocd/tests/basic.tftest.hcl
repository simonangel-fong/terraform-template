# Plan-only tests. The Helm provider is mocked so this runs in CI without
# a real Kubernetes cluster. For tests that need real apply behavior, write a
# separate *.tftest.hcl that uses the real provider and run it locally.

mock_provider "helm" {}

run "defaults" {
  command = plan

  assert {
    condition     = helm_release.this.name == "argocd"
    error_message = "Helm release name should be 'argocd'."
  }

  assert {
    condition     = helm_release.this.chart == "argo-cd"
    error_message = "Chart name should be 'argo-cd'."
  }

  assert {
    condition     = helm_release.this.repository == "https://argoproj.github.io/argo-helm"
    error_message = "Repository should point at the argo-helm repo."
  }

  assert {
    condition     = helm_release.this.namespace == "argocd"
    error_message = "Namespace should default to 'argocd'."
  }

  assert {
    condition     = helm_release.this.create_namespace == true
    error_message = "create_namespace should be true so the chart provisions the namespace."
  }

  assert {
    condition     = helm_release.this.version == "9.7.0"
    error_message = "Chart version should default to 9.7.0."
  }
}

run "custom_namespace_and_version" {
  command = plan

  variables {
    argocd_version = "9.8.0"
    namespace      = "gitops"
  }

  assert {
    condition     = helm_release.this.namespace == "gitops"
    error_message = "Namespace should match var.namespace."
  }

  assert {
    condition     = helm_release.this.version == "9.8.0"
    error_message = "Chart version should match var.argocd_version."
  }
}
