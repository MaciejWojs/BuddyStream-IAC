provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  skip_credentials_validation = var.skip_aws_checks
  skip_metadata_api_check     = var.skip_aws_checks
  skip_requesting_account_id  = var.skip_aws_checks
  s3_use_path_style           = var.s3_use_path_style

  endpoints {
    s3 = coalesce(var.aws_s3_endpoint, "https://s3.${var.aws_region}.amazonaws.com")
  }
}
