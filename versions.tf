terraform {
  required_version = ">= 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0, < 7.0"
    }
  }

  # backend "s3" {
  #   bucket  = "REPLACE_WITH_YOUR_STATE_BUCKET"
  #   key     = "sdds/dev/terraform.tfstate"
  #   region  = "us-east-1"
  #   encrypt = true
  # }

  #for local development
  backend "local" {
    path = "terraform.tfstate"
  }
}
