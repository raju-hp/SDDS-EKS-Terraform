variable "region" {
  type    = string
  default = "us-east-1"
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
