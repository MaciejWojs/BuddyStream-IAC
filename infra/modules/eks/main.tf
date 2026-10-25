resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

# Provider aws_eks_cluster wymaga co najmniej jednej podsieci. We Floci to pusta
# sieć, na której wisi klaster. OpenTofu nie opisuje Deploymentów ani obrazów.
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_subnet" "this" {
  for_each = {
    a = "10.0.1.0/24"
    b = "10.0.2.0/24"
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = "${var.aws_region}${each.key}"

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids = [for subnet in aws_subnet.this : subnet.id]
  }

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}
