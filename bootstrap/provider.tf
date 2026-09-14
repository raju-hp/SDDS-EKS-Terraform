variable "region" {
  type    = string
  default = "us-east-1"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

variable "github_org" {
  type = string
}

variable "github_repo" {
  type = string
}

provider "aws" {
  region = var.region
}
