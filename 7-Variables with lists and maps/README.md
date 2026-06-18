# 7 - Variables with Lists and Maps

## What You Learn
- Use `list` type variables (ordered, accessed by index)
- Use `map` type variables (key-value pairs, accessed by key)
- Create multiple resources with different configurations

## Files
- `provider.tf` — AWS provider
- `variables.tf` — List and map variable declarations
- `main.tf` — Resources using list/map lookups

## Steps

### 1. `variables.tf` — Define lists and maps:

```hcl
variable "ec2_name_tag" {
  default = ["prod-instance", "dev-instance", "test-instance"]
}

variable "instance_type" {
  #              index: 0          1           2
  default = ["t2.medium", "t2.micro", "t2.small"]
  type    = list(string)
}

variable "ami_ids" {
  default = {
    linux  = "ami-0c02fb55956c7d316"
    ubuntu = "ami-0261755bbcb8c4a84"
  }
  type = map(string)
}
```

### 2. `main.tf` — Access by index (list) or key (map):

```hcl
# Access list by index: var.list[0]
# Access map by key: var.map["key"]

resource "aws_instance" "prod-instance" {
  ami           = var.ami_ids["linux"]       # Map lookup
  instance_type = var.instance_type[0]       # List index 0 = t2.medium
  tags = {
    Name = var.ec2_name_tag[0]               # "prod-instance"
  }
}

resource "aws_instance" "dev-instance" {
  ami           = var.ami_ids["ubuntu"]      # Map lookup
  instance_type = var.instance_type[1]       # List index 1 = t2.micro
  tags = {
    Name = var.ec2_name_tag[1]               # "dev-instance"
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

## Key Concepts
- **List** — ordered, access by index `[0]`, `[1]`, `[2]`
- **Map** — key-value, access by key `["linux"]`, `["ubuntu"]`
- Lists are great for multiple similar values
- Maps are great for lookups (AMI per OS, instance type per env)
