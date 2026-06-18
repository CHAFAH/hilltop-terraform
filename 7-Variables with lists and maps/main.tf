# List access: var.list[index]
# Map access: var.map["key"]

resource "aws_instance" "prod" {
  ami           = var.ami_ids["linux"]     # Map lookup by key
  instance_type = var.instance_types[0]    # List index 0 = t3.medium

  tags = {
    Name = var.instance_names[0]           # "prod-server"
  }
}

resource "aws_instance" "dev" {
  ami           = var.ami_ids["ubuntu"]    # Map lookup by key
  instance_type = var.instance_types[1]    # List index 1 = t2.micro

  tags = {
    Name = var.instance_names[1]           # "dev-server"
  }
}
