# 5 - Variables with tfvars Files

## What You Learn
- Use `.tfvars` files to set variable values per environment
- Keep variable declarations separate from values
- Deploy to different environments using the same code

## Files
- `provider.tf` — AWS provider
- `variables.tf` — Variable declarations (no defaults)
- `main.tf` — Resource using variables
- `variables/dev.tfvars` — Values for dev environment

## Steps

### 1. `variables.tf` — Declare variables (no defaults):

```hcl
variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
  default     = 1
}

variable "instance_name" {
  description = "Name tag for the instance"
  type        = string
}
```

### 2. `variables/dev.tfvars` — Set values for dev:

```hcl
aws_region     = "us-east-1"
instance_type  = "t2.micro"
ami_id         = "ami-0c02fb55956c7d316"
instance_count = 1
instance_name  = "dev-server"
```

### 3. Create more tfvars for other environments:

`variables/prod.tfvars`:
```hcl
aws_region     = "us-east-1"
instance_type  = "t3.large"
ami_id         = "ami-0c02fb55956c7d316"
instance_count = 3
instance_name  = "prod-server"
```

### 4. `main.tf` — Use the variables:

```hcl
resource "aws_instance" "prod-instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count         = var.instance_count
  tags = {
    Name = var.instance_name
  }
}
```

### 5. Run with specific tfvars file:

```bash
terraform init

# Deploy to dev
terraform plan -var-file="variables/dev.tfvars"
terraform apply -var-file="variables/dev.tfvars"

# Deploy to prod
terraform plan -var-file="variables/prod.tfvars"
terraform apply -var-file="variables/prod.tfvars"

# Destroy
terraform destroy -var-file="variables/dev.tfvars"
```

## Why Use tfvars
- Same Terraform code for all environments
- Environment-specific values in separate files
- Easy to add new environments (just create a new `.tfvars`)
- Never edit the main `.tf` files when changing environments

## Auto-loaded tfvars
- `terraform.tfvars` — auto-loaded if present
- `*.auto.tfvars` — auto-loaded if present
- All others require `-var-file="filename"`
