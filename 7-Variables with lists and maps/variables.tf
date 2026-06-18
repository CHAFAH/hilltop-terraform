variable "instance_names" {
  description = "List of instance name tags"
  type        = list(string)
  default     = ["prod-server", "dev-server", "test-server"]
}

variable "instance_types" {
  description = "List of instance types (access by index)"
  type        = list(string)
  default     = ["t3.medium", "t2.micro", "t2.small"]
}

variable "ami_ids" {
  description = "Map of OS to AMI ID (access by key)"
  type        = map(string)
  default = {
    linux  = "ami-0c02fb55956c7d316"
    ubuntu = "ami-0261755bbcb8c4a84"
  }
}
