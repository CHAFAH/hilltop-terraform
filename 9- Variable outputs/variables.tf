variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the instance"
  type        = string
  default     = "output-demo-instance"
}
