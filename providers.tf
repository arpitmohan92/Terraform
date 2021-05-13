terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = var.region
  access_key = "AKIAUMLSKDND46O3M35I"
  secret_key = "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"
}
