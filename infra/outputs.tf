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
