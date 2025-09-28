variable "vpc_id" {}

variable "use_nat" {}
variable "igw_id" {}

variable "dynamic_subnet_types" {
  type    = list(string)
  description = "It will use when dynamic subents selected"
  default = ["private", "data", "public"]
}

variable "azs" {
  type = list(string)
  description = "AZ"
  default = [ "us-west-1a", "us-west-1b", "us-west-1c" ]
}

variable "subnets" {
  type = list(object({
    type = string
    cidr_block = list(string)
  }))
  default = [
    {
      type = "public"
      cidr_block = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
    },
    {
      type = "private"
      cidr_block = ["10.0.10.0/24","10.0.11.0/24","10.0.12.0/24"]
    },
    {
      type = "data"
      cidr_block = ["10.0.20.0/24","10.0.21.0/24","10.0.22.0/24"]
    },
  ]
}

variable "create_dynamic_subnets" {
  description = "Set to true to create dynamic subnets, set to false to use static subnets"
  type        = bool
  default     = false
}

variable "common_tags" {
    type = map(string)
    default = {
        env     = "development"
        team    = "devops"
        purpose = "general"
    }
}

variable "use_individual_nat_gateways" {
  description = "Set to true if you want a NAT gateway in each public subnet."
  type        = bool
  default     = false
}