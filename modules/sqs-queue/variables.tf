variable "queue_name" {
  description = "Name of the SQS queue"
  type        = string
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue (in seconds)"
  type        = number
  default     = 30
}

variable "create_dlq" {
  description = "Whether to create a dead-letter queue (DLQ)"
  type        = bool
  default     = false
}

variable "max_receive_count" {
  description = "Maximum number of times a message can be received before being sent to DLQ"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
