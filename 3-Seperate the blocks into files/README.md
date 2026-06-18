# 3 - Separate Blocks into Files

## What You Learn
- Terraform project structure best practice
- Split provider and resources into separate files
- Terraform automatically reads all `.tf` files in a directory

## Files
- `provider.tf` — AWS provider configuration
- `ec2.tf` — EC2 resource definition

## Steps

### 1. `provider.tf` — Define where to deploy:

```hcl
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}
```

### 2. `ec2.tf` — Define what to deploy:

```hcl
resource "aws_instance" "prod-instance" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  tags = {
    Name = "prod-server"
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

## Why Separate Files
- Easier to read and maintain
- Team members can work on different files
- Standard convention in all Terraform projects:
  - `provider.tf` — provider config
  - `main.tf` — resources
  - `variables.tf` — input variables
  - `outputs.tf` — output values
