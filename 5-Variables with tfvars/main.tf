resource "aws_instance" "server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count         = var.instance_count

  tags = {
    Name = "${var.instance_name}-${count.index + 1}"
  }
}
