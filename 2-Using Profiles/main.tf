resource "aws_instance" "web-server" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  tags = {
    Name = "web-server-profile"
  }
}
