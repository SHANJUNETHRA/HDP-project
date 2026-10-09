
variable "aws_region" {
  description = "AWS region for our project"
  type        = string
  default     = "ap-south-1"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "devops-key"
}