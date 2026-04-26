# SQS Queue Tests
# Uses Terraform's native test framework (terraform test) to validate the sqs-queue module.
# Run these tests with LocalStack running: terraform test

# ─── Test 1: Basic queue creation ────────────────────────────────────────────

run "queue_is_created" {
  variables {
    queue_name                 = "test-basic-queue"
    visibility_timeout_seconds = 30
    create_dlq                 = false
  }

  assert {
    condition     = output.queue_name == "test-basic-queue"
    error_message = "Queue name output does not match the expected value"
  }

  assert {
    condition     = length(output.queue_url) > 0
    error_message = "Queue URL output should not be empty"
  }

  assert {
    condition     = length(output.queue_arn) > 0
    error_message = "Queue ARN output should not be empty"
  }
}

# ─── Test 2: Custom visibility timeout ───────────────────────────────────────

run "custom_visibility_timeout" {
  variables {
    queue_name                 = "test-timeout-queue"
    visibility_timeout_seconds = 120
    create_dlq                 = false
  }

  assert {
    condition     = output.queue_name == "test-timeout-queue"
    error_message = "Queue name output does not match when custom timeout is set"
  }
}

# ─── Test 3: Queue with DLQ ───────────────────────────────────────────────────

run "queue_with_dlq" {
  variables {
    queue_name                 = "test-queue-with-dlq"
    visibility_timeout_seconds = 30
    create_dlq                 = true
    max_receive_count          = 5
  }

  assert {
    condition     = output.queue_name == "test-queue-with-dlq"
    error_message = "Queue name output does not match when DLQ is enabled"
  }

  assert {
    condition     = output.dlq_url != null
    error_message = "DLQ URL should not be null when create_dlq is true"
  }

  assert {
    condition     = output.dlq_arn != null
    error_message = "DLQ ARN should not be null when create_dlq is true"
  }
}

# ─── Test 4: No DLQ outputs when DLQ disabled ────────────────────────────────

run "no_dlq_when_disabled" {
  variables {
    queue_name  = "test-no-dlq-queue"
    create_dlq  = false
  }

  assert {
    condition     = output.dlq_url == null
    error_message = "DLQ URL should be null when create_dlq is false"
  }

  assert {
    condition     = output.dlq_arn == null
    error_message = "DLQ ARN should be null when create_dlq is false"
  }
}
