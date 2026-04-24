# Test harness for the s3-bucket module.
# The .tftest.hcl files in this directory drive variables into this configuration.

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
  # Required so S3 requests go to localhost:4566/<bucket> instead of
  # <bucket>.localhost:4566 (virtual-hosted style), which doesn't resolve.
  s3_use_path_style = true

  endpoints {
    s3 = "http://localhost:4566"
  }
}

module "s3_bucket" {
  source = "../../modules/s3-bucket"

  bucket_name       = var.bucket_name
  enable_versioning = var.enable_versioning
  enable_encryption = var.enable_encryption
  tags              = var.tags
}
