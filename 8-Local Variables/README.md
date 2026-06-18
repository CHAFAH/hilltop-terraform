# 8 - Local Variables

## What You Learn
- Use `locals` block for computed or repeated values
- Reduce duplication by defining tag sets once
- Difference between `variable` (input) and `locals` (internal)

## Files
- `provider.tf` — AWS provider
- `variables.tf` — Input variables (ami, instance type)
- `main.tf` — Locals block + resources using `local.<name>`

## Steps

### 1. `main.tf` — Define locals and use them:

```hcl
locals {
  prod_tag = {
    Project = "Migration project"
    Team    = "devops-team"
    Env     = "prod-environment"
  }

  dev_tag = {
    Project = "Migration project"
    Team    = "devops-team"
    Env     = "dev-environment"
  }
}

resource "aws_instance" "prod-instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags          = local.prod_tag
}

resource "aws_instance" "dev-instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags          = local.dev_tag
}
```

### 2. `variables.tf`:

```hcl
variable "ami_id" {
  default = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  default = "t2.micro"
}
```

### 3. Run:

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Variable vs Local

| | `variable` | `locals` |
|-|-----------|----------|
| Purpose | Input from user/tfvars | Internal computed values |
| Syntax | `var.name` | `local.name` |
| Can override at runtime | ✅ | ❌ |
| Use for | Reusable inputs | DRY repeated values |
