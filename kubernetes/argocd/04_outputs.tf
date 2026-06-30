# outputs.tf

output "namespace" {
  description = "Namespace Argo CD was installed into."
  value       = helm_release.this.namespace
}

output "release_name" {
  description = "Name of the Helm release."
  value       = helm_release.this.name
}

output "chart_version" {
  description = "Argo CD Helm chart version that was installed."
  value       = helm_release.this.version
}
