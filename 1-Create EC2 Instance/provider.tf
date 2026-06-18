terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote backend (uncomment after creating S3 bucket and DynamoDB table)
  # backend "s3" {
  #   bucket         = "landmark-terraform-state"
  #   key            = "1-ec2-basic/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = "us-east-1"
}
