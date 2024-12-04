/*
output "url_api" {
  value = length(kubernetes_service.LoadBalancer-api) > 0 ? kubernetes_service.LoadBalancer-api[0].status[0].load_balancer[0].ingress[0].hostname : data.kubernetes_service.existing_service_ms_pedido.status[0].load_balancer[0].ingress[0].hostname
  description = "The URL of the API"
}

*/


output "teste" {
  value = module.eks
}