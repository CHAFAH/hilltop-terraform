# 11 - Terraform Modules Advanced (Multi-Environment)

## What You Learn
- Use modules with different tfvars per environment
- Deploy the same infrastructure to dev, test, and prod
- Combine modules + tfvars for production-grade structure

## Structure

```
11-Terraform Modules Advanced/
├── main.tf               ← Calls modules
├── provider.tf           ← AWS provider
├── variables.tf          ← Variable declarations
├── modules/
│   ├── ec2/              ← EC2 module
│   ├── s3/              ← S3 module
│   └── vpc/             ← VPC module
└── variable-values/
    ├── dev.tfvars        ← Dev environment values
    ├── test.tfvars       ← Test environment values
    └── prod.tfvars       ← Prod environment values
```

## Steps

### 1. Deploy to dev:

```bash
terraform init
terraform plan -var-file="variable-values/dev.tfvars"
terraform apply -var-file="variable-values/dev.tfvars"
```

### 2. Deploy to prod:

```bash
terraform plan -var-file="variable-values/prod.tfvars"
terraform apply -var-file="variable-values/prod.tfvars"
```

### 3. Destroy:

```bash
terraform destroy -var-file="variable-values/dev.tfvars"
```

## Key Concept
Same code, different values per environment. The modules stay the same — only the `.tfvars` file changes.
