resource "helm_release" "consul" {
  name  = "consul"
  chart = "hashicorp/consul"

  values = [
    "${file("./helm/consul-values.yml")}"
  ]
}
