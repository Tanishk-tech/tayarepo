variable "common_tags" {
  description = "tags"
  type        = map(string)
  default = {
    "proj"      = "taya"
    "env"       = "dev"
    "CreatedBy" = "terraform"
  }
}

variable "region" {
  default     = "us-east-1"
  type        = string
  description = "region"
}

variable "vpc_name" {
  type    = string
  default = "vpc"

}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "172.16.0.0/16"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "VPC Enable DNS hostname resolving"
  default     = true
}

variable "dynamic_subnet_types" {
  type        = list(string)
  description = "It will use when dynamic subents selected"
  default     = ["private", "data", "public"]
}

variable "azs" {
  type        = list(string)
  description = "AZ"
  default     = ["us-east-1a", "us-east-1b"]
}


variable "subnets" {
  type = list(object({
    type       = string
    cidr_block = list(string)
  }))
  default = [
    {
      type       = "public"
      cidr_block = ["172.16.1.0/24", "172.16.2.0/24"]
    },
    {
      type       = "private"
      cidr_block = ["172.16.3.0/24", "172.16.4.0/24"]
    },
    {
      type       = "data"
      cidr_block = ["172.16.5.0/24", "172.16.6.0/24"]
    },
  ]
}

variable "create_dynamic_subnets" {
  description = "Set to true to create dynamic subnets, set to false to use static subnets"
  type        = bool
  default     = false
}

variable "use_individual_nat_gateways" {
  description = "Set to true if you want a NAT gateway in each public subnet."
  type        = bool
  default     = true
}
