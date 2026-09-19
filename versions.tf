terraform {
  required_version = ">= 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0, < 7.0"
    }
  }

  backend "s3" {
    region  = "us-east-1"
    encrypt = true
  }
  #for local development
  # backend "local" {
  #   path = "terraform.tfstate"
  # }
}