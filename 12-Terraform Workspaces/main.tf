# terraform.workspace returns the current workspace name (e.g., "dev", "prod")

resource "aws_instance" "server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "${var.instance_name}-${terraform.workspace}"
    Env  = terraform.workspace
  }
}

resource "aws_s3_bucket" "storage" {
  bucket = "${var.bucket_name}-${terraform.workspace}"

  tags = {
    Name = "${var.bucket_name}-${terraform.workspace}"
    Env  = terraform.workspace
  }
}
