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

module "eks" {
  count  = var.enable_eks ? 1 : 0
  source = "./modules/eks"

  cluster_name       = "${var.project}-${var.environment}"
  kubernetes_version = var.kubernetes_version
  aws_region         = var.aws_region
  project            = var.project
  environment        = var.environment
}
