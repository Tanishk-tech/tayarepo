variable "ami" {
  description = "AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be created"
  type        = string
}

variable "key_name" {
  description = "Key pair name"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the instance"
  type        = string
}

variable "common_tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}


variable "vpc_id" {
  description = "VPC ID"
  type = string
}