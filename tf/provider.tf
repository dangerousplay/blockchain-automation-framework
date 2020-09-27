provider "helm" {
  repository_config_path = "./helm/repository.yml"

  dynamic "kubernetes" {
    for_each = terraform.workspace == "default" ? [] : [1]

    content {
      host     = "https://104.196.242.174"
      username = "ClusterMaster"
      password = "MindTheGap"

      client_certificate     = "${file("~/.kube/client-cert.pem")}"
      client_key             = "${file("~/.kube/client-key.pem")}"
      cluster_ca_certificate = "${file("~/.kube/cluster-ca-cert.pem")}"
    }
  }
}


