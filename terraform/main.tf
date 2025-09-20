locals {
  cluster_name = "${var.project_name}-eks"
}

# VPC (using the widely-used community module)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

# EKS cluster (using the community module)
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 3
      desired_size = 2
      instance_types = ["t3.medium"]
    }
  }

  enable_cluster_creator_admin_permissions = true
}


# KMS Key for EKS
resource "aws_kms_key" "cluster" {
  description             = "KMS key for EKS cluster"
  enable_key_rotation     = true
  deletion_window_in_days = 30
}

# KMS Alias for EKS
resource "aws_kms_alias" "cluster_alias" {
  name          = "alias/eks/devops-project-3-eks-new"
  target_key_id = aws_kms_key.cluster.id
}

resource "aws_kms_alias" "cluster_alias" {
  name          = "alias/eks/devops-project-4-eks-new"
  target_key_id = aws_kms_key.cluster.id
}

#  CloudWatch Log Group for EKS
resource "aws_cloudwatch_log_group" "eks_log_group" {
  name              = "/aws/eks/devops-project-5-eks-new/cluster"
  retention_in_days = 90
}

# GitHub OIDC provider for AWS (needed to assume role from GitHub Actions)
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    # GitHub Actions OIDC root CA thumbprint
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

# IAM role for GitHub Actions to deploy (least privileges for ECR push + EKS describe)
resource "aws_iam_role" "gha_deployer" {
  name = "${var.project_name}-gha-deployer"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" : [
            "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/main",
            "repo:${var.github_owner}/${var.github_repo}:pull_request"
          ]
        },
        StringEquals = {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        }
      }
    }]
  })
}

# Policy allowing: push to ECR and describe EKS cluster
data "aws_iam_policy_document" "gha_policy" {
  statement {
    sid    = "ECRPushPull"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = ["*"]
  }

  statement {
    sid     = "EKSDescribe"
    effect  = "Allow"
    actions = ["eks:DescribeCluster"]
    resources = [module.eks.cluster_arn]
  }
}

resource "aws_iam_policy" "gha_inline" {
  name   = "${var.project_name}-gha-policy"
  policy = data.aws_iam_policy_document.gha_policy.json
}

resource "aws_iam_role_policy_attachment" "gha_attach" {
  role       = aws_iam_role.gha_deployer.name
  policy_arn = aws_iam_policy.gha_inline.arn
}

# Map the IAM role into Kubernetes admins so helm/kubectl can deploy
module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16.0" # check latest on Terraform Registry

  cluster_name        = module.eks.cluster_name
  cluster_endpoint    = module.eks.cluster_endpoint
  cluster_version     = module.eks.cluster_version
  oidc_provider_arn   = module.eks.oidc_provider_arn

  enable_cluster_autoscaler     = true
  enable_metrics_server         = true
  enable_kube_prometheus_stack  = true
}
