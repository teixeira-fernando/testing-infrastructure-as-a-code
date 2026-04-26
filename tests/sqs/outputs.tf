output "queue_url" {
  description = "The URL of the SQS queue"
  value       = module.sqs_queue.queue_url
}

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = module.sqs_queue.queue_arn
}

output "queue_name" {
  description = "The name of the SQS queue"
  value       = module.sqs_queue.queue_name
}

output "dlq_url" {
  description = "The URL of the dead-letter queue (if created)"
  value       = module.sqs_queue.dlq_url
}

output "dlq_arn" {
  description = "The ARN of the dead-letter queue (if created)"
  value       = module.sqs_queue.dlq_arn
}
