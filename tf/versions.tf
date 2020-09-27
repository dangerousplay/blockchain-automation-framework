terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    docker = {
      source = "terraform-providers/docker"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  required_version = ">= 0.13"
}
