# 12 - Terraform Workspaces

## What You Learn
- Use workspaces to manage multiple environments with one config
- `terraform.workspace` variable gives the current workspace name
- Each workspace has its own state file

## Files
- `provider.tf` — AWS provider
- `variable.tf` — Input variables
- `main.tf` — Resources using `terraform.workspace`

## How Workspaces Work

```
default workspace (state: terraform.tfstate)
dev workspace     (state: terraform.tfstate.d/dev/terraform.tfstate)
prod workspace    (state: terraform.tfstate.d/prod/terraform.tfstate)
```

## Steps

### 1. `main.tf` — Use workspace name in resources:

```hcl
resource "aws_instance" "prod-instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = format("%s_%s", var.instance_name, terraform.workspace)
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "hilltop-resources-${terraform.workspace}"
  tags = {
    Name = format("%s-%s", var.bucket_name, terraform.workspace)
  }
}
```

### 2. Create and switch workspaces:

```bash
terraform init

# List workspaces
terraform workspace list

# Create workspaces
terraform workspace new dev
terraform workspace new prod

# Switch to dev and deploy
terraform workspace select dev
terraform apply

# Switch to prod and deploy
terraform workspace select prod
terraform apply

# Check current workspace
terraform workspace show
```

### 3. Destroy a specific workspace:

```bash
terraform workspace select dev
terraform destroy
terraform workspace select default
terraform workspace delete dev
```

## Workspace vs tfvars

| Approach | State Separation | When to Use |
|----------|:----------------:|-------------|
| Workspaces | ✅ Auto | Simple projects, same backend |
| tfvars + separate backends | ✅ Manual | Production, different AWS accounts |

## Notes
- `default` workspace always exists and can't be deleted
- `terraform.workspace` returns the workspace name as a string
- Each workspace has completely isolated state
