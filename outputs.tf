output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "efs_file_system_id" {
  value = module.efs.file_system_id
}

output "secrets_manager_arn" {
  value = module.secrets.secret_arn
}

output "cloudwatch_log_group" {
  value = module.cloudwatch.log_group_name
}

output "efs_access_point_id" {
  value = module.efs.access_point_id
}
