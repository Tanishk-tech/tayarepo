variable "vpc_name" {
    type = string
    default = "myVPC"
  
}

variable "vpc_cidr" {
  type = string
  description = "VPC CIDR"
  default = "10.0.0.0/24"
}
variable "enable_dns_hostnames" {
    type = bool
    description = "VPC Enable DNS hostname resolving"
    default = true
}

variable "common_tags" {}