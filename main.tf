provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = module.eks.endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

module "vpc" {
  source = "github.com/fiap-postech-36/vpc-infrastructure?ref=v1.0.0"

  name                 = var.project_name
  vpc_cidr             = "12.0.0.0/16"
  public_subnet_cidrs  = ["12.0.7.0/24", "12.0.8.0/24", "12.0.9.0/24"]
  private_subnet_cidrs = []
}

module "eks" {
  source = "./modules/eks"

  cluster_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  default_region    = var.aws_region
  security_group_id = aws_security_group.sg_cluster_ms.id
  create_eks = true

  depends_on = [module.vpc]
}