locals {
  prod_tags = {
    Name    = "prod-server"
    Project = "landmark-project"
    Team    = "devops"
    Env     = "production"
  }

  dev_tags = {
    Name    = "dev-server"
    Project = "landmark-project"
    Team    = "devops"
    Env     = "development"
  }
}

resource "aws_instance" "prod" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags          = local.prod_tags
}

resource "aws_instance" "dev" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags          = local.dev_tags
}
