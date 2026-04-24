# Test harness for the sqs-queue module.
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

  endpoints {
    sqs = "http://localhost:4566"
  }
}

module "sqs_queue" {
  source = "../../modules/sqs-queue"

  queue_name                 = var.queue_name
  visibility_timeout_seconds = var.visibility_timeout_seconds
  create_dlq                 = var.create_dlq
  max_receive_count          = var.max_receive_count
  tags                       = var.tags
}
