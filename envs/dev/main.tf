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
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.8.0/24"]
  private_subnet_cidrs = []
}

resource "aws_db_parameter_group" "database-params" {
  name   = "db-parameter-group-${var.project_name}"
  family = "postgres15"

  parameter {
    name  = "log_connections"
    value = "1"
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_db_instance" "database-created" {
  identifier             = "db-${var.project_name}"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "15"
  username               = var.POSTGRE_DEFAULT_PASS
  password               = var.POSTGRE_DEFAULT_PASS
  db_name                = var.POSTGRE_DATABASE_NAME
  vpc_security_group_ids = [aws_security_group.sg_cluster.id]
  parameter_group_name   = aws_db_parameter_group.database-params.name
  publicly_accessible    = false
  skip_final_snapshot    = true
  lifecycle {
    prevent_destroy = false
  }
}

module "eks" {
  source = "../../modules/eks"

  cluster_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  default_region    = var.aws_region
  security_group_id = aws_security_group.sg_cluster.id

  depends_on = [module.vpc, aws_db_instance.database-created]
}