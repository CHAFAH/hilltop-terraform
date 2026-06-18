# 9 - Variable Outputs

## What You Learn
- Use `output` blocks to display resource attributes after apply
- Retrieve useful info like instance ID, public IP, ARN
- Outputs can be used by other modules or scripts

## Files
- `provider.tf` — AWS provider
- `variables.tf` — Input variables
- `main.tf` — EC2 resource
- `output.tf` — Output declarations

## Steps

### 1. `main.tf` — Create a resource:

```hcl
resource "aws_instance" "prod-instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.instance_tag
  }
}
```

### 2. `output.tf` — Expose values after apply:

```hcl
output "instance_id" {
  value = aws_instance.prod-instance.id
}

output "instance_public_ip" {
  value = aws_instance.prod-instance.public_ip
}
```

### 3. Run:

```bash
terraform init
terraform plan
terraform apply
```

After apply, you'll see:
```
Outputs:

instance_id = "i-0abc123def456789"
instance_public_ip = "54.123.45.67"
```

### 4. View outputs anytime:

```bash
terraform output
terraform output instance_public_ip
```

### 5. Cleanup:

```bash
terraform destroy
```

## Common Outputs
- `id` — Resource ID
- `arn` — Amazon Resource Name
- `public_ip` — Public IP address
- `private_ip` — Private IP address
- `dns_name` — DNS name (for load balancers)

## Why Use Outputs
- Display important info after deployment
- Pass values between modules
- Use in scripts: `terraform output -raw instance_public_ip`
