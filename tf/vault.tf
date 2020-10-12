
locals {
  VAULT_DEV_ROOT_TOKEN = "MYTOKEN"
  VAULT_EXTERNAL_PORT = 8200
}

//hashicorp/vault
resource "docker_container" "vault" {
  name  = "vault"
  image = "vault:1.5.4"
  env = ["VAULT_DEV_ROOT_TOKEN_ID=${local.VAULT_DEV_ROOT_TOKEN}", "VAULT_LOG_LEVEL=debug"]

  ports {
    internal = 8200
    external = local.VAULT_EXTERNAL_PORT
  }
}

output "vault_root_token" {
  value = local.VAULT_DEV_ROOT_TOKEN
}

output "vault_host" {
  value = docker_container.vault.ip_address
}

output "vault_port" {
  value = local.VAULT_EXTERNAL_PORT
}
