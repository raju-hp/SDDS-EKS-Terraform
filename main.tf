module "vpc" {
  source = "./modules/vpc"

  name               = var.name
  cidr_block         = var.cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
  tags               = var.tags
}

module "eks" {
  source = "./modules/eks"

  name                    = "${var.name}-eks"
  kubernetes_version      = var.eks_kubernetes_version
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnets
  node_instance_types     = var.eks_node_instance_types
  node_min_size           = var.eks_node_min_size
  node_desired_size       = var.eks_node_desired_size
  node_max_size           = var.eks_node_max_size
  cluster_log_types       = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  tags                    = var.tags
  github_actions_role_arn = var.github_actions_role_arn
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = "${var.project_name}/sdds"
  tags            = var.tags
}

module "efs" {
  source = "./modules/efs"

  name            = "${var.name}-sdds-efs"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  allowed_sg_ids  = [module.eks.node_security_group_id]
  throughput_mode = var.efs_throughput_mode
  tags            = var.tags
}

module "secrets" {
  source = "./modules/secrets"

  secret_name     = var.sdds_secret_name
  username        = var.sdds_username
  password        = var.sdds_password
  cluster_name    = module.eks.cluster_name
  namespace       = "sdds"
  service_account = "sdds-app"
  tags            = var.tags
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  cluster_name       = module.eks.cluster_name
  log_retention_days = var.log_retention_days
  tags               = var.tags
}
