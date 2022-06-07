terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
  }
}

provider "kubernetes" {
  config_context = "minikube"
  config_path    = "~/.kube/config"
}
provider "helm" {
  kubernetes {
    config_context = "minikube"
    config_path    = "~/.kube/config"
  }
}

resource "helm_release" "guestbook" {
  name    = "guestbook"
  chart   = "${path.module}/guestbook"
  version = "0.1.0"

  depends_on = [null_resource.helm_update]

  values = [
    "${file("./guestbook/values.yaml")}"
  ]
}

resource "null_resource" "helm_update" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "helm dep build guestbook"
  }
}
