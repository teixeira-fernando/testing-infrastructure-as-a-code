# Testing Infrastructure as Code with Terraform

Practical examples of how to test AWS infrastructure defined with **Terraform**, using the **Terraform native testing framework** (`terraform test`) and **LocalStack** for realistic local integration testing — no real AWS account required.

---

## 🎯 Purpose

This repository is educational. It demonstrates:

- How to write reusable Terraform modules for AWS (S3 and SQS)
- How to validate infrastructure with `terraform test` (`.tftest.hcl` files)
- How to run tests fully locally using [LocalStack](https://docs.localstack.cloud/overview/)
- How to automate everything with a GitHub Actions CI pipeline

---

## 📁 Folder Structure

```
.
├── modules/
│   ├── s3-bucket/        # Reusable S3 bucket module
│   └── sqs-queue/        # Reusable SQS queue module (with optional DLQ)
│
├── examples/
│   ├── s3-basic/         # Example: deploy an S3 bucket via the module
│   └── sqs-basic/        # Example: deploy an SQS queue with DLQ via the module
│
├── tests/
│   ├── s3/               # Terraform test files for the S3 module
│   └── sqs/              # Terraform test files for the SQS module
│
├── localstack/
│   ├── docker-compose.yml  # Runs LocalStack locally
│   └── init-scripts/       # Optional startup scripts executed by LocalStack
│
├── .github/
│   └── workflows/
│       └── terraform-tests.yml  # CI pipeline (GitHub Actions)
│
└── README.md
```

---

## 🛠️ Tech Stack

| Tool | Version | Purpose |
|------|---------|---------|
| Terraform | ≥ 1.6 | Infrastructure as Code |
| AWS Provider | ~5.0 | AWS resource management |
| `terraform test` | built-in | Native test framework |
| LocalStack | 3.4 | Local AWS emulation |
| Docker / Compose | latest | Container runtime |
| GitHub Actions | — | CI pipeline |

---

## 🚀 Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) with Docker Compose v2
- [Terraform](https://developer.hashicorp.com/terraform/install) ≥ 1.6

### 1. Start LocalStack

```bash
docker compose -f localstack/docker-compose.yml up -d
```

Wait until LocalStack is healthy:

```bash
curl http://localhost:4566/_localstack/health
# Expected: {"status": "running", ...}
```

### 2. Run the S3 tests

```bash
cd tests/s3
terraform init
terraform test
```

### 3. Run the SQS tests

```bash
cd tests/sqs
terraform init
terraform test
```

### 4. Stop LocalStack

```bash
docker compose -f localstack/docker-compose.yml down
```

---

## 🧪 Testing Strategy

Tests live in `tests/s3/` and `tests/sqs/`. Each directory contains:

| File | Purpose |
|------|---------|
| `main.tf` | Test harness — calls the module under test |
| `variables.tf` | Input variables accepted by the harness |
| `outputs.tf` | Outputs exposed to the test assertions |
| `*.tftest.hcl` | Test scenarios with `run` blocks and `assert` statements |

### What is tested

**S3 module**

- Basic bucket creation — validates `bucket_name` and `bucket_arn` outputs
- Versioning enabled — confirms the bucket is created with versioning on
- Encryption enabled — confirms the bucket is created with AES-256 encryption
- Both versioning and encryption enabled simultaneously

**SQS module**

- Basic queue creation — validates `queue_name`, `queue_url`, `queue_arn` outputs
- Custom visibility timeout
- Queue with DLQ — validates `dlq_url` and `dlq_arn` are non-null
- No DLQ when disabled — validates `dlq_url` and `dlq_arn` are null

> Tests interact with real LocalStack resources — no mocking.

---

## ⚙️ CI Pipeline

The GitHub Actions workflow (`.github/workflows/terraform-tests.yml`) runs on every push and pull request:

1. **Start LocalStack** via Docker Compose
2. **Wait** until LocalStack's health endpoint reports `running`
3. **Install Terraform** (hashicorp/setup-terraform)
4. **`terraform init` + `terraform validate`** for each module
5. **`terraform test`** for S3 and SQS test suites
6. On failure — **print LocalStack logs** for debugging

---

## 📦 Modules

### `modules/s3-bucket`

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `bucket_name` | `string` | — | Name of the S3 bucket |
| `enable_versioning` | `bool` | `false` | Enable object versioning |
| `enable_encryption` | `bool` | `false` | Enable AES-256 server-side encryption |
| `tags` | `map(string)` | `{}` | Resource tags |

Outputs: `bucket_name`, `bucket_arn`

### `modules/sqs-queue`

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `queue_name` | `string` | — | Name of the SQS queue |
| `visibility_timeout_seconds` | `number` | `30` | Visibility timeout |
| `create_dlq` | `bool` | `false` | Create a dead-letter queue |
| `max_receive_count` | `number` | `3` | Max receives before DLQ |
| `tags` | `map(string)` | `{}` | Resource tags |

Outputs: `queue_name`, `queue_url`, `queue_arn`, `dlq_url`, `dlq_arn`

---

## 📄 License

[MIT](LICENSE)
