output "url_api" {
  value       = kubernetes_service.LoadBalancer.status[0].load_balancer[0].ingress[0].hostname
  description = "The URL of the API"
}

output "endpoint_db" {
  value = aws_db_instance.database-created.endpoint
  description = "The endpoint of the database"
}