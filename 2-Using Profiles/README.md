# 2 - Using AWS Profiles

## What You Learn
- Authenticate using AWS CLI profiles instead of hardcoded keys
- Cleaner and more secure provider configuration

## Prerequisites

Configure AWS CLI first:

```bash
aws configure
# Enter: Access Key, Secret Key, Region, Output format
```

This creates `~/.aws/credentials` and `~/.aws/config`.

## Files
- `ec2.tf` — Provider uses the default profile (no keys in code)

## Steps

### 1. Configure your provider to use the CLI profile:

```hcl
provider "aws" {
  region = "us-east-1"
}
```

When no `access_key`/`secret_key` is specified, Terraform automatically uses `~/.aws/credentials`.

To use a named profile:

```hcl
provider "aws" {
  region  = "us-east-1"
  profile = "my-profile-name"
}
```

### 2. Define the resource:

```hcl
resource "aws_instance" "prod-instance" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  tags = {
    Name = "Terraform"
  }
}
```

### 3. Run:

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Why This Is Better
- No secrets in code
- Credentials managed by AWS CLI
- Safe to commit `.tf` files to Git
