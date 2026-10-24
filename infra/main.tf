locals {
  bucket_name = coalesce(var.bucket_name, "${var.project}-${var.environment}")
}

module "s3" {
  source = "./modules/s3"

  bucket_name   = local.bucket_name
  force_destroy = var.force_destroy
  project       = var.project
  environment   = var.environment
}
