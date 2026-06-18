# Terraform — Infrastructure as Code

---

## Table of Contents

1. [What is Terraform](#what-is-terraform)
2. [History](#history)
3. [What Terraform Does](#what-terraform-does)
4. [Alternatives](#alternatives)
5. [Installation](#installation)
6. [AWS CLI Installation](#aws-cli-installation)
7. [Terraform Setup with AWS](#terraform-setup-with-aws)
8. [Terraform Commands](#terraform-commands)
9. [Terraform Keywords](#terraform-keywords)
10. [Data Types](#data-types)
11. [Functions](#functions)
12. [Terraform Providers](#terraform-providers)

---

## What is Terraform

Terraform is an open-source **Infrastructure as Code (IaC)** tool created by HashiCorp. It lets you define cloud and on-premises infrastructure in human-readable configuration files (HCL — HashiCorp Configuration Language), then provision and manage that infrastructure through a consistent workflow.

**Key characteristics:**
- Declarative — you describe the desired state, Terraform figures out how to get there
- Cloud-agnostic — works with AWS, Azure, GCP, Kubernetes, and 3,000+ providers
- State-based — tracks what it created so it can update or destroy resources
- Idempotent — running the same config multiple times produces the same result

---

## History

| Year | Event |
|------|-------|
| 2014 | HashiCorp releases Terraform 0.1 (open-source) |
| 2017 | Terraform 0.10 — provider/plugin separation |
| 2019 | Terraform 0.12 — major HCL2 syntax upgrade |
| 2020 | Terraform 0.13 — module `for_each`, provider source requirements |
| 2021 | Terraform 1.0 — stability guarantee, production-ready |
| 2022 | Terraform 1.3 — optional object attributes, moved blocks |
| 2023 | HashiCorp changes license to BSL (Business Source License) |
| 2023 | OpenTofu forked as open-source alternative |
| 2024 | Terraform 1.7+ — testing framework, removed provisioners |

---

## What Terraform Does

Terraform manages infrastructure lifecycle through APIs:

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│    WRITE     │────────▶│     PLAN     │────────▶│    APPLY     │
│              │         │              │         │              │
│ Define .tf   │         │ Preview      │         │ Create/Update│
│ files        │         │ changes      │         │ infrastructure│
└──────────────┘         └──────────────┘         └──────────────┘
```

**Use cases:**
- Provision cloud infrastructure (EC2, VPC, RDS, EKS, S3, etc.)
- Manage Kubernetes clusters and resources
- Configure DNS, CDN, monitoring
- Set up multi-cloud environments
- Automate infrastructure in CI/CD pipelines
- Manage SaaS services (GitHub repos, Datadog monitors, PagerDuty)

---

## Alternatives

| Tool | Type | Comparison to Terraform |
|------|------|------------------------|
| **AWS CloudFormation** | IaC (AWS only) | AWS-native, no state file, slower |
| **Pulumi** | IaC (multi-cloud) | Uses real programming languages (Python, Go, TypeScript) |
| **OpenTofu** | IaC (multi-cloud) | Open-source fork of Terraform (same syntax) |
| **Ansible** | Configuration Management | Procedural, better for OS config, not ideal for cloud infra |
| **AWS CDK** | IaC (AWS only) | Write infra in TypeScript/Python, generates CloudFormation |
| **Crossplane** | IaC (Kubernetes-native) | Manages cloud resources as K8s CRDs |

---

## Installation

### Windows

```powershell
# Option 1: Chocolatey
choco install terraform

# Option 2: Manual
# 1. Download from https://developer.hashicorp.com/terraform/install
# 2. Extract zip to C:\terraform
# 3. Add C:\terraform to System PATH:
#    - Search "Environment Variables" → System variables → Path → Edit → New → C:\terraform
# 4. Verify
terraform -version
```

### macOS

```bash
# Option 1: Homebrew (recommended)
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Option 2: Manual
# Download from https://developer.hashicorp.com/terraform/install
# Extract and move to /usr/local/bin/

# Verify
terraform -version
```

### Linux (Ubuntu/Debian)

```bash
# Add HashiCorp GPG key and repo
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Install
sudo apt update && sudo apt install terraform -y

# Verify
terraform -version
```

### Linux (Amazon Linux / RHEL / CentOS)

```bash
# Add repo
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# Install
sudo yum install terraform -y

# Verify
terraform -version
```

---

## AWS CLI Installation

Terraform needs the AWS CLI configured to authenticate with AWS.

### Windows

```powershell
# Download and run the installer
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

# Or download manually from: https://awscli.amazonaws.com/AWSCLIV2.msi
# Verify
aws --version
```

### macOS

```bash
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
aws --version
```

### Linux

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

---

## Terraform Setup with AWS

### Step 1: Configure AWS Credentials

```bash
aws configure
```

Enter:
```
AWS Access Key ID: AKIAXXXXXXXXXXXXXXXX
AWS Secret Access Key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Default region name: us-east-1
Default output format: json
```

This creates `~/.aws/credentials` and `~/.aws/config`.

### Step 2: Create a Terraform Project

```bash
mkdir my-infra && cd my-infra
```

### Step 3: Define Provider (main.tf)

```hcl
terraform {
  required_version = ">= 1.0"
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

### Step 4: Initialize and Apply

```bash
terraform init      # Download provider plugins
terraform plan      # Preview changes
terraform apply     # Create resources
```

### Alternative: Specify Credentials Directly (not recommended)

```hcl
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAXXXXXXXXXXXXXXXX"
  secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
```

> ⚠️ Never hardcode credentials in `.tf` files. Use `aws configure`, environment variables, or IAM roles instead.

### Environment Variables (alternative to aws configure)

```bash
export AWS_ACCESS_KEY_ID="AKIAXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
export AWS_DEFAULT_REGION="us-east-1"
```

---

## Terraform Commands

| Command | Purpose |
|---------|---------|
| `terraform init` | Initialize working directory, download providers |
| `terraform plan` | Preview what will be created/changed/destroyed |
| `terraform apply` | Apply changes to create/update infrastructure |
| `terraform destroy` | Destroy all managed infrastructure |
| `terraform validate` | Check syntax and configuration for errors |
| `terraform fmt` | Format `.tf` files to canonical style |
| `terraform show` | Show current state or a plan |
| `terraform state list` | List all resources in state |
| `terraform state show <resource>` | Show details of a specific resource |
| `terraform output` | Show output values |
| `terraform import <resource> <id>` | Import existing infrastructure into state |
| `terraform taint <resource>` | Mark resource for recreation on next apply |
| `terraform refresh` | Update state to match real infrastructure |
| `terraform workspace list` | List workspaces |
| `terraform workspace new <name>` | Create a new workspace |
| `terraform graph` | Generate dependency graph (DOT format) |

### Common Workflow

```bash
terraform init          # First time only (or when providers change)
terraform fmt           # Format code
terraform validate      # Check for errors
terraform plan          # Review changes
terraform apply         # Deploy (type 'yes' to confirm)
terraform destroy       # Tear down (type 'yes' to confirm)
```

### Auto-approve (skip confirmation — use in CI/CD)

```bash
terraform apply -auto-approve
terraform destroy -auto-approve
```

---

## Terraform Keywords

| Keyword | Purpose | Example |
|---------|---------|---------|
| `resource` | Define infrastructure to create | `resource "aws_instance" "web" {}` |
| `provider` | Configure cloud provider | `provider "aws" { region = "us-east-1" }` |
| `variable` | Declare input parameters | `variable "region" { default = "us-east-1" }` |
| `output` | Expose values after apply | `output "ip" { value = aws_instance.web.public_ip }` |
| `data` | Query existing resources | `data "aws_ami" "latest" {}` |
| `module` | Reuse grouped resources | `module "vpc" { source = "./modules/vpc" }` |
| `locals` | Define local computed values | `locals { name = "${var.env}-app" }` |
| `terraform` | Configure Terraform settings | `terraform { required_version = ">= 1.0" }` |
| `backend` | Configure state storage | `backend "s3" { bucket = "my-state" }` |
| `provisioner` | Run scripts after creation (deprecated) | `provisioner "remote-exec" {}` |
| `dynamic` | Generate repeated blocks | `dynamic "ingress" { ... }` |
| `for_each` | Create multiple instances from a map/set | `for_each = var.instances` |
| `count` | Create multiple instances by number | `count = 3` |
| `depends_on` | Explicit dependency | `depends_on = [aws_vpc.main]` |
| `lifecycle` | Control resource behavior | `lifecycle { prevent_destroy = true }` |

---

## Data Types

| Type | Description | Example |
|------|-------------|---------|
| `string` | Text | `"us-east-1"` |
| `number` | Integer or float | `8080` |
| `bool` | True or false | `true` |
| `list` | Ordered collection | `["us-east-1a", "us-east-1b"]` |
| `map` | Key-value pairs | `{ name = "web", env = "prod" }` |
| `set` | Unordered unique values | `toset(["a", "b", "c"])` |
| `object` | Structured type | `{ name = string, port = number }` |
| `tuple` | Fixed-length typed list | `[string, number, bool]` |

---

## Functions

| Function | Purpose | Example |
|----------|---------|---------|
| `format` | Format string | `format("Hello %s", var.name)` |
| `join` | Join list to string | `join(",", var.list)` |
| `split` | Split string to list | `split(",", "a,b,c")` |
| `length` | Length of list/map/string | `length(var.subnets)` |
| `lookup` | Get value from map | `lookup(var.amis, "us-east-1")` |
| `element` | Get item by index | `element(var.azs, 0)` |
| `file` | Read file contents | `file("scripts/init.sh")` |
| `templatefile` | Render template with vars | `templatefile("user_data.tpl", { port = 8080 })` |
| `cidrsubnet` | Calculate subnet CIDR | `cidrsubnet("10.0.0.0/16", 8, 1)` |
| `max` / `min` | Max/min of numbers | `max(5, 12, 9)` |
| `tolist` / `toset` / `tomap` | Type conversion | `tolist(var.items)` |
| `try` | Return first non-error value | `try(var.optional, "default")` |
| `can` | Test if expression is valid | `can(regex("^ami-", var.ami))` |
| `flatten` | Flatten nested lists | `flatten([["a"], ["b", "c"]])` |
| `merge` | Merge maps | `merge(var.defaults, var.overrides)` |
| `keys` / `values` | Get map keys or values | `keys(var.tags)` |

---

## Terraform Providers

Providers are plugins that let Terraform interact with APIs. Over 3,000 providers exist on the [Terraform Registry](https://registry.terraform.io/).

### Common Providers

| Provider | Purpose |
|----------|---------|
| `hashicorp/aws` | Amazon Web Services |
| `hashicorp/azurerm` | Microsoft Azure |
| `hashicorp/google` | Google Cloud Platform |
| `hashicorp/kubernetes` | Kubernetes |
| `hashicorp/helm` | Helm charts |
| `integrations/github` | GitHub repos, teams |
| `hashicorp/random` | Random values |
| `hashicorp/null` | Null resources (triggers) |

### Provider Configuration Example

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
  region = var.region
}
```

---

## References

- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Terraform Registry](https://registry.terraform.io/)
- [AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
