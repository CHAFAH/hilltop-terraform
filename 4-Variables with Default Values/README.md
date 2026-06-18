# 4 - Variables with Default Values

## What You Learn
- Declare variables with the `variable` block
- Use default values so you don't have to pass them every time
- Reference variables with `var.<name>`

## Files
- `provider.tf` — AWS provider
- `variables.tf` — Variable declarations with defaults
- `ec2.tf` — Resource referencing variables

## Steps

### 1. `variables.tf` — Declare variables:

```hcl
variable "ami_id" {
  default = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ec2_name_tag" {
  default = "my-terraform-instance"
}
```

### 2. `ec2.tf` — Use the variables:

```hcl
resource "aws_instance" "instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.ec2_name_tag
  }
}
```

### 3. `provider.tf`:

```hcl
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}
```

### 4. Run:

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

### Override defaults at runtime:

```bash
terraform apply -var="instance_type=t3.medium" -var="ec2_name_tag=prod-server"
```

## Why Use Variables
- Reusable configurations
- Change values without editing resource blocks
- Different values per environment (dev, staging, prod)
