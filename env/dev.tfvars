region       = "us-east-1"
project_name = "sdds"
# Set this after bootstrap. Example:
# github_actions_role_arn = "arn:aws:iam::123456789012:role/sdds-github-actions"
environment = "dev"

name       = "dev-sdds"
cidr_block = "10.0.0.0/16"

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnets = [
  "10.0.10.0/24",
  "10.0.11.0/24"
]

availability_zones = [
  "us-east-1a",
  "us-east-1b"
]

eks_kubernetes_version = "1.36"

eks_node_instance_types = ["t3.medium"]
eks_node_min_size       = 2
eks_node_desired_size   = 2
eks_node_max_size       = 4

sdds_secret_name = "sdds/dev/application"
sdds_username    = "sdds"

# Prefer supplying the password at runtime:
# PowerShell:
#   $env:TF_VAR_sdds_password = "..."
# Linux/macOS:
#   export TF_VAR_sdds_password='...'

tags = {
  Application = "SDDS"
  Owner       = "DevOps"
}
