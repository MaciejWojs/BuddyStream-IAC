output "bucket_name" {
  description = "Nazwa bucketa."
  value       = aws_s3_bucket.main.bucket
}

output "bucket_arn" {
  description = "ARN bucketa."
  value       = aws_s3_bucket.main.arn
}
