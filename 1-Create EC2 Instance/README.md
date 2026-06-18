# 1 - Terraform Provider, State File & Backend

## What You Learn
- What a Terraform provider is and why it's needed
- What the state file is and why it matters
- Types of backends (local vs remote)
- How to set up S3 backend with DynamoDB locking
- Creating your first resource (EC2)

---

## What is a Provider?

A provider is a plugin that tells Terraform HOW to talk to a cloud platform's API. Without a provider, Terraform doesn't know how to create anything.

```
Your .tf files → Terraform → Provider Plugin → AWS API → Infrastructure
```

Every Terraform project MUST have at least one provider configured.

### AWS Provider Example

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

**What `terraform init` does:**
- Reads the provider requirements
- Downloads the provider plugin (e.g., `hashicorp/aws` v5.x)
- Stores it in `.terraform/` directory

---

## What is the State File?

When Terraform creates resources, it records what it created in a **state file** (`terraform.tfstate`). This file is a JSON mapping between your `.tf` code and the real infrastructure.

```
┌──────────────┐         ┌──────────────────┐         ┌──────────────┐
│  .tf files   │         │ terraform.tfstate │         │  Real AWS    │
│  (desired)   │◀───────▶│   (what exists)   │◀───────▶│  Resources   │
└──────────────┘         └──────────────────┘         └──────────────┘
```

**Why state matters:**
- Terraform compares desired state (.tf) vs current state (tfstate) to know what to create, update, or delete
- Without state, Terraform would try to create everything from scratch every time
- State contains sensitive data (resource IDs, IPs, sometimes passwords)

**State file rules:**
- ⚠️ Never edit it manually
- ⚠️ Never commit it to Git (add `terraform.tfstate` to `.gitignore`)
- ✅ Store it remotely for team collaboration

---

## Backend — Where State is Stored

### Local Backend (Default)

State saved on your local machine at `./terraform.tfstate`.

**Problems:**
- Lost if machine dies
- Can't collaborate — team members have different state
- No locking — two people applying at once = corruption

### Remote Backend (S3) — Recommended

State saved in S3 with DynamoDB locking.

**Benefits:**
- Durable (S3 is 99.999999999% durable)
- Shared across team
- Locked — only one apply at a time
- Versioned — can rollback state
- Encrypted at rest

### Types of Backends

| Backend | Storage | Locking | Use Case |
|---------|---------|:-------:|----------|
| `local` | Local disk | ❌ | Learning only |
| `s3` | AWS S3 | ✅ (DynamoDB) | AWS teams |
| `azurerm` | Azure Blob | ✅ | Azure teams |
| `gcs` | GCS Bucket | ✅ | GCP teams |
| `remote` | Terraform Cloud | ✅ | HCP Terraform |

---

## Setting Up S3 Backend with DynamoDB Locking

### Step 1: Create S3 Bucket

```bash
aws s3api create-bucket \
  --bucket my-terraform-state-bucket \
  --region us-east-1

# Enable versioning
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

> The table MUST have a primary key named `LockID` (String type).

### Step 3: Configure Backend in Terraform

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "project-name/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}
```

### Step 4: Initialize

```bash
terraform init
```

If migrating from local state, Terraform asks:
```
Do you want to copy existing state to the new backend? yes
```

### How Locking Works

```
User A: terraform apply
  → Writes lock to DynamoDB (LockID = state path)
  → Apply runs...

User B: terraform apply (same time)
  → Checks DynamoDB → lock exists
  → ERROR: "Error acquiring the state lock"
  → Must wait for User A to finish

User A finishes:
  → Lock removed from DynamoDB
  → User B can now proceed
```

---

## Creating Your First Resource (EC2)

### `ec2.tf`:

```hcl
resource "aws_instance" "my-server" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  tags = {
    Name = "my-first-terraform-instance"
  }
}
```

### Run:

```bash
terraform init      # Download provider, configure backend
terraform plan      # Preview: 1 resource to create
terraform apply     # Create EC2 (type 'yes')
terraform destroy   # Destroy EC2 (type 'yes')
```

---

## Files in This Folder
- `ec2.tf` — Provider + EC2 resource

## .gitignore (add to your project root)

```
.terraform/
*.tfstate
*.tfstate.backup
*.tfvars
```

---

## Summary

| Concept | Purpose |
|---------|---------|
| Provider | Plugin that connects Terraform to a cloud API |
| State file | Tracks what Terraform created |
| Backend | Where the state file is stored |
| S3 backend | Remote state storage (durable, shared) |
| DynamoDB | State locking (prevents concurrent applies) |
| `terraform init` | Downloads provider + configures backend |
