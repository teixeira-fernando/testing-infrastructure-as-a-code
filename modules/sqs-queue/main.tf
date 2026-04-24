# SQS Queue Module
# Creates an SQS queue with optional dead-letter queue (DLQ) support.

# Optional dead-letter queue
resource "aws_sqs_queue" "dlq" {
  count = var.create_dlq ? 1 : 0
  name  = "${var.queue_name}-dlq"

  tags = var.tags
}

# Main SQS queue
resource "aws_sqs_queue" "this" {
  name                       = var.queue_name
  visibility_timeout_seconds = var.visibility_timeout_seconds

  # Attach DLQ redrive policy when DLQ is enabled
  redrive_policy = var.create_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = var.tags
}
