provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context_cluster = "minikube"
}
resource "kubernetes_namespace" "dvwa" {
  metadata {
    name = "dvwa"
  }
}

resource "kubernetes_deployment" "dvwa" {
  metadata {
    name = "dvwa"
    namespace = kubernetes_namespace.dvwa.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "dvwa"
      }
    }
    template {
      metadata {
        labels = {
          app = "dvwa"
        }
      }
      spec {
        container {
          image = "vulnerables/web-dvwa"
          name = "dvwa"
          port {
            container_port = 80
            name = "http"
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "dvwa" {
  metadata {
    name = "dvwa"
    namespace = kubernetes_namespace.dvwa.metadata.0.name
  }
  spec {
    selector = {
      app = "dvwa"
    }
    type = "NodePort"
    port {
      port = 80
      target_port = 80
      node_port = 30800
    }
  }
}