# 10 - Terraform Modules (Basic)

## What You Learn
- Organize code into reusable modules
- Call modules from a root configuration
- Pass variables into modules and get outputs

## Structure

```
10-Terraform Modules/
├── main.tf           ← Root: calls the modules
├── provider.tf       ← AWS provider
├── variables.tf      ← Root variables
├── output.tf         ← Root outputs
├── ec2/
│   ├── main.tf       ← EC2 resource
│   ├── variables.tf  ← Module inputs
│   └── output.tf     ← Module outputs
├── s3/
│   ├── main.tf       ← S3 resource
│   ├── variables.tf  ← Module inputs
│   └── outputs.tf    ← Module outputs
└── vpc/
    ├── main.tf       ← VPC resource
    ├── variables.tf  ← Module inputs
    └── output.tf     ← Module outputs
```

## Steps

### 1. Root `main.tf` — Call modules:

```hcl
module "vpc" {
  source         = "./vpc"
  vpc_name       = var.vpc_name
  vpc_cidr_block = var.vpc_cidr_block
}

module "mys3" {
  source      = "./s3"
  bucket_name = var.bucket_name
}

module "prod-instance" {
  source        = "./ec2"
  ami_id        = var.ami_id
  ec2_name      = var.ec2_name
  instance_type = var.instance_type
}
```

### 2. Module structure (e.g., `ec2/main.tf`):

```hcl
resource "aws_instance" "instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.ec2_name
  }
}
```

### 3. Module variables (`ec2/variables.tf`):

```hcl
variable "ami_id" {}
variable "instance_type" {}
variable "ec2_name" {}
```

### 4. Run:

```bash
terraform init    # Downloads module dependencies
terraform plan
terraform apply
terraform destroy
```

## Why Use Modules
- **Reusability** — Write once, use everywhere
- **Organization** — Clean separation of concerns
- **Consistency** — Same module = same standards
- **Team collaboration** — Teams own their modules
