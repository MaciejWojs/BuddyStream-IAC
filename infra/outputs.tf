output "bucket_name" {
  description = "Nazwa utworzonego bucketa."
  value       = module.s3.bucket_name
}

output "bucket_arn" {
  description = "ARN bucketa. We Floci to lokalna atrapa."
  value       = module.s3.bucket_arn
}

output "environment" {
  description = "Środowisko użyte przy tym apply."
  value       = var.environment
}

output "cluster_name" {
  description = "Nazwa klastra EKS. Null, gdy enable_eks = false."
  value       = one(module.eks[*].cluster_name)
}

output "cluster_endpoint" {
  description = "Adres API klastra."
  value       = one(module.eks[*].cluster_endpoint)
}

output "update_kubeconfig" {
  description = "Podpina kubectl. We Floci klucz test/test nie przejdzie webhooka klastra."
  value = var.enable_eks ? join(" ", compact([
    "aws eks update-kubeconfig",
    "--name ${one(module.eks[*].cluster_name)}",
    "--region ${var.aws_region}",
    var.aws_s3_endpoint == null ? null : "--endpoint-url ${var.aws_s3_endpoint}",
  ])) : null
}
