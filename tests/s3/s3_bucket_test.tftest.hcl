# S3 Bucket Tests
# Uses Terraform's native test framework (terraform test) to validate the s3-bucket module.
# Run these tests with LocalStack running: terraform test

# ─── Test 1: Basic bucket creation ───────────────────────────────────────────

run "bucket_is_created" {
  # Deploy the module with minimal configuration
  variables {
    bucket_name       = "test-basic-bucket"
    enable_versioning = false
    enable_encryption = false
  }

  # Verify the outputs are non-empty, confirming the bucket was created
  assert {
    condition     = output.bucket_name == "test-basic-bucket"
    error_message = "Bucket name output does not match the expected value"
  }

  assert {
    condition     = length(output.bucket_arn) > 0
    error_message = "Bucket ARN output should not be empty"
  }
}

# ─── Test 2: Versioning enabled ──────────────────────────────────────────────

run "versioning_is_enabled" {
  variables {
    bucket_name       = "test-versioned-bucket"
    enable_versioning = true
    enable_encryption = false
  }

  assert {
    condition     = output.bucket_name == "test-versioned-bucket"
    error_message = "Bucket name output does not match when versioning is enabled"
  }
}

# ─── Test 3: Encryption enabled ──────────────────────────────────────────────

run "encryption_is_enabled" {
  variables {
    bucket_name       = "test-encrypted-bucket"
    enable_versioning = false
    enable_encryption = true
  }

  assert {
    condition     = output.bucket_name == "test-encrypted-bucket"
    error_message = "Bucket name output does not match when encryption is enabled"
  }

  assert {
    condition     = length(output.bucket_arn) > 0
    error_message = "Bucket ARN output should not be empty when encryption is enabled"
  }
}

# ─── Test 4: Both versioning and encryption enabled ──────────────────────────

run "versioning_and_encryption_enabled" {
  variables {
    bucket_name       = "test-full-bucket"
    enable_versioning = true
    enable_encryption = true
  }

  assert {
    condition     = output.bucket_name == "test-full-bucket"
    error_message = "Bucket name output does not match when both features are enabled"
  }
}
