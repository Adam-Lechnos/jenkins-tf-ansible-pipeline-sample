terraform {
  required_providers {
    aws-default = {
      source  = "hashicorp/aws"
      version = "~> 3.68.0"
    }
  }
}

provider "aws-default" {
  region = var.aws_region
}