output "endpoint" {
  value = length(aws_eks_cluster.cluster-created) > 0 ? aws_eks_cluster.cluster-created[0].endpoint : "Cluster not created"
}

output "cluster_name" {
  value = length(aws_eks_cluster.cluster-created) > 0 ? aws_eks_cluster.cluster-created[0].name : var.cluster_name
}

output "cluster_ca_certificate" {
  value = length(aws_eks_cluster.cluster-created) > 0 ? aws_eks_cluster.cluster-created[0].certificate_authority[0].data : "No certificate available"
}
