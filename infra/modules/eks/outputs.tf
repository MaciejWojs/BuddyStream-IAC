output "cluster_name" {
  description = "Nazwa klastra EKS."
  value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "ARN klastra."
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "Adres API klastra. We Floci to localhost i port z zakresu 6500-6599."
  value       = aws_eks_cluster.this.endpoint
}
