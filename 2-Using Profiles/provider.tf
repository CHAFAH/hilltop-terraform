terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Using AWS CLI profile (configured via: aws configure)
# No access keys in code — credentials come from ~/.aws/credentials
provider "aws" {
  region  = "us-east-1"
  # profile = "my-named-profile"  # Uncomment to use a named profile
}
