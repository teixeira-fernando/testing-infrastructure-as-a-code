# SQS Basic Example
# Demonstrates creating an SQS queue with DLQ using the sqs-queue module against LocalStack.

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

  queue_name                 = "my-example-queue"
  visibility_timeout_seconds = 60
  create_dlq                 = true
  max_receive_count          = 5

  tags = {
    Environment = "local"
    ManagedBy   = "terraform"
  }
}

output "queue_url" {
  value = module.sqs_queue.queue_url
}

output "queue_arn" {
  value = module.sqs_queue.queue_arn
}

output "dlq_url" {
  value = module.sqs_queue.dlq_url
}
