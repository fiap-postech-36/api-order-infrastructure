resource "kubernetes_deployment" "rabbitmq" {
  metadata {
    name = var.project_name
    labels = {
      name = "${var.project_name}-deployment"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "${var.project_name}-pod"
      }
    }

    template {
      metadata {
        name = "${var.project_name}-pod"
        labels = {
          app = "${var.project_name}-pod"
        }
      }

      spec {
        container {
          image = "kaique98/api-order-group-36:latest"
          name  = "${var.project_name}-container"

          env_from {
            config_map_ref {
              name = kubernetes_config_map.api-configmap.metadata[0].name
            }
          }

          resources {
            limits = {
              cpu = "500m"
            }
            requests = {
              cpu = "10m"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "LoadBalancer" {
  metadata {
    name = "load-balancer-${var.project_name}"
  }
  spec {
    selector = {
      app = "${var.project_name}-pod"
    }
    port {
      name        = "http"
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_config_map" "api-configmap" {
  metadata {
    name = "${var.project_name}-configmap"
  }

  data = {
    SPRING_DATASOURCE_URL: aws_db_instance.database-created.endpoint
    SPRING_DATASOURCE_URL : var.POSTGRE_DEFAULT_PASS
    SPRING_DATASOURCE_PASSWORD : var.POSTGRE_DEFAULT_PASS
    RABBIT_HOST: var.RABBITMQ_HOST
    RABBIT_USER: var.RABBITMQ_DEFAULT_USER
    RABBIT_PASSWORD: var.RABBITMQ_DEFAULT_PASS
  }
}