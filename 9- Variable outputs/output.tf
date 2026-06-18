output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.server.id
}

output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.server.public_ip
}

output "instance_arn" {
  description = "The ARN of the EC2 instance"
  value       = aws_instance.server.arn
}
