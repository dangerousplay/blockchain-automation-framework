#ansible-playbook platforms/shared/configuration/site.yaml -e "@./platforms/hyperledger-fabric/configuration/network.yaml"
/*
resource "null_resource" "test_box" {

  provisioner "ansible" {
    plays {
      playbook {
        file_path = "../platforms/shared/configuration/site.yaml"
      }
    }
  }
}*/
