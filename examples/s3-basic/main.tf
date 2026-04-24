# S3 Basic Example
# Demonstrates creating an S3 bucket using the s3-bucket module against LocalStack.

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS provider to point at LocalStack
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = "http://localhost:4566"
  }
}

module "s3_bucket" {
  source = "../../modules/s3-bucket"

  bucket_name       = "my-example-bucket"
  enable_versioning = true
  enable_encryption = true

  tags = {
    Environment = "local"
    ManagedBy   = "terraform"
  }
}

output "bucket_name" {
  value = module.s3_bucket.bucket_name
}

output "bucket_arn" {
  value = module.s3_bucket.bucket_arn
}
