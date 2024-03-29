provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "tf-k8s-deployment" {
  metadata {
    name = "tf-k8s-deploy"
    labels = {
      name = "terraform-k8s-deployment"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        name = "terraform-k8s-deployment"
      }
    }

    template {
      metadata {
        labels = {
          name = "terraform-k8s-deployment"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "nginx"

        }
      }
    }
  }
}
resource "kubernetes_service" "tf-k8s-service" {
  metadata {
    name = "terraform-k8s-service"
    labels = {
      name = "tf-k8s-deploy"
    }
  }
  spec {
    port {
      port        = 80
      target_port = 80
      node_port   = 30080
    }
    type = "NodePort"
  }
}