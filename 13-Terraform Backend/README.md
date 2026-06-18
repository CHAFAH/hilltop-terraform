# 13 - Terraform Backend (S3 + DynamoDB Locking)

## What You Learn
- Store Terraform state remotely in S3
- Enable state locking with DynamoDB to prevent concurrent modifications
- Types of backends and why remote state matters

## Files
- `backend.tf` — S3 backend configuration
- `main.tf` — Resources to create
- `variables.tf` — Input variables
- `output.tf` — Outputs

## Why Remote Backend?

By default, Terraform stores state locally (`terraform.tfstate`). Problems:
- Lost if your laptop dies
- Can't collaborate (two people running at once = corruption)
- No locking = simultaneous applies can break infrastructure

**Remote backend (S3) solves this:**
- State stored in S3 (durable, versioned)
- DynamoDB provides locking (only one apply at a time)
- Team can share state safely

## Types of Backends

| Backend | Storage | Locking | Use Case |
|---------|---------|:-------:|----------|
| `local` | Local disk | ❌ | Learning only |
| `s3` | AWS S3 | ✅ (DynamoDB) | Most common for AWS |
| `azurerm` | Azure Blob | ✅ | Azure projects |
| `gcs` | Google Cloud Storage | ✅ | GCP projects |
| `consul` | HashiCorp Consul | ✅ | Multi-cloud |
| `remote` | Terraform Cloud | ✅ | HCP Terraform |

## Setup Steps

### Step 1: Create S3 Bucket (manually or via CLI)

```bash
aws s3api create-bucket \
  --bucket my-terraform-state-bucket \
  --region us-east-1

# Enable versioning (recommended)
aws s3api put-bucket-versioning \
  --bucket my-terraform-state-bucket \
  --versioning-configuration Status=Enabled
```

### Step 2: Create DynamoDB Table for Locking

```bash
aws dynamodb create-table \
  --table-name terraform-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

> **Important:** The DynamoDB table MUST have a primary key named `LockID` (type String). This is what Terraform uses for locking.

### Step 3: Configure Backend (`backend.tf`)

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
```

### Step 4: Initialize with Backend

```bash
terraform init
```

If migrating from local to S3, Terraform will ask:
```
Do you want to copy existing state to the new backend? (yes/no)
```
Type `yes`.

### Step 5: Apply as normal

```bash
terraform plan
terraform apply
```

State is now stored in S3 and locked via DynamoDB.

## Verify

```bash
# Check state in S3
aws s3 ls s3://my-terraform-state-bucket/terraform/

# Check DynamoDB lock (should be empty when no apply is running)
aws dynamodb scan --table-name terraform-lock
```

## How Locking Works

```
User A runs: terraform apply
  → Terraform writes lock to DynamoDB (LockID = state file path)
  → Apply runs...

User B runs: terraform apply (at the same time)
  → Terraform checks DynamoDB → lock exists
  → ERROR: "Error acquiring the state lock"
  → User B must wait for User A to finish

User A finishes:
  → Lock removed from DynamoDB
  → User B can now run
```

## Backend Configuration Options

| Option | Purpose |
|--------|---------|
| `bucket` | S3 bucket name |
| `key` | Path within bucket for state file |
| `region` | AWS region of the bucket |
| `dynamodb_table` | DynamoDB table for locking |
| `encrypt` | Encrypt state at rest (SSE-S3) |
| `profile` | AWS CLI profile to use |

## Notes
- Backend config cannot use variables — values must be hardcoded or passed via `-backend-config`
- Always enable S3 versioning so you can recover previous state
- One state file per environment (use different `key` paths)
- Example multi-env keys:
  - `dev/terraform.tfstate`
  - `staging/terraform.tfstate`
  - `prod/terraform.tfstate`
