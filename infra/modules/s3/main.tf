resource "aws_s3_bucket" "main" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}
