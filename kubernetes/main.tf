terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.16.0"
    }
  }
}

provider "kubernetes" {
  # Configuration options
  config_path = "~/.kube/config"
}

resource "null_resource" "kubectl_kubegres" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/reactive-tech/kubegres/v1.16/kubegres.yaml"
    interpreter = ["/bin/bash", "-c"]
  }
}

