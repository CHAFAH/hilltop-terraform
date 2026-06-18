# 1 - Create EC2 Instance (Basic)

## What You Learn
- Terraform provider configuration
- Resource block syntax
- How to authenticate with AWS using access keys

## Files
- `ec2.tf` — Provider + Resource in a single file

## Steps

### 1. Add your AWS credentials and resource details in `ec2.tf`:

```hcl
resource "aws_instance" "my-server" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  tags = {
    Name = "my-first-terraform-instance"
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "<your-access-key>"
  secret_key = "<your-secret-key>"
}
```

### 2. Run Terraform:

```bash
terraform init      # Download AWS provider
terraform plan      # Preview the EC2 instance to be created
terraform apply     # Create the instance (type 'yes')
terraform destroy   # Destroy when done (type 'yes')
```

## Notes
- ⚠️ Never commit access keys to Git. This approach is for learning only.
- In production, use `aws configure` or IAM roles instead.
- `terraform init` must be run once before any other command.
