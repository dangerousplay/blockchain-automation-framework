
resource "helm_repository" "prometheus" {
  name = "prometheus-community"
  url = "https://prometheus-community.github.io/helm-charts"
}

resource "helm_repository" "hashicorp" {
  name = "hashicorp"
  url = "https://helm.releases.hashicorp.com"
}

resource "helm_repository" "fluxcd" {
  name = "fluxcd"
  url = "https://charts.fluxcd.io"
}

resource "helm_repository" "stable" {
  name = "stable"
  url = "https://kubernetes-charts.storage.googleapis.com/"
}
