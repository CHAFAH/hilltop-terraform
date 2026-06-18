variable "ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Base name for the instance"
  type        = string
  default     = "workspace-server"
}

variable "bucket_name" {
  description = "Base name for S3 bucket"
  type        = string
  default     = "landmark-resources"
}
