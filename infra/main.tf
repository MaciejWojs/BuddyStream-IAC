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

check "api_gateway_backend_url" {
  assert {
    condition     = !var.enable_api_gateway || try(length(trimspace(var.api_gateway_backend_url)) > 0, false)
    error_message = "api_gateway_backend_url jest wymagany, gdy enable_api_gateway = true."
  }
}

module "api_gateway" {
  count  = var.enable_api_gateway ? 1 : 0
  source = "./modules/api-gateway"

  name                     = "${var.project}-${var.environment}"
  stage_name               = var.environment
  backend_base_url         = var.enable_api_gateway ? var.api_gateway_backend_url : "http://127.0.0.1"
  domain_name              = var.api_gateway_domain_name
  regional_certificate_arn = var.api_gateway_certificate_arn
  project                  = var.project
  environment              = var.environment
}
