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
  default = "vpc"
  type    = string
}

variable "vpc_cidr" {
  default     = "172.16.0.0/16"
  type        = string
  description = "vpc cidr"
}

variable "enable_dns_hostnames" {
  default     = true
  description = "VPC Enable DNS hostname resolving"
  type        = bool
}


variable "azs" {
  default     = ["us-east-1a", "us-east-1b"]
  description = "az"
  type        = list(string)
}

variable "subnets" {
  type = list(object({
    type       = string
    cidr_block = list(string)
  }))
  default = [{
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
    }
  ]
}

variable "use_nat" {
  type        = bool
  default     = true
  description = "nat require or not"
}

variable "use_individual_nat_gateways" {
  description = "Set to true if you want a NAT gateway in each public subnet."
  type        = bool
  default     = true
}

variable "ec2_pub_keys" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCNYjoaliKFaDAv9QpVoZ5/shTpRSSZfGucLhkpV5eyqXx73Px1+8Nr1KkbnWB8M1DEyddbaYhmX5wn502Kd7Bl4flOtBAlaf/CbaGqqIO7sntmBCTtCorePY56PQZdH5DR26OhVPmAk0LAV6RDoO968E4KDuGLtcT8gjvXciDV2HTFQKGQ4xMYftavplFTDVRFTF9BjXfApTfU6C5IDByj9zqxTbCnDEmz34vmhOqfGWA6ts8S5UFuH4kL5QAroX3F7YkVXjwfe8Fvch4Q7kWSsdh6jva/dxM+zzzL0sZ+v2yucaZn08UOsz+JSwsC2DkKbAdVdplOS2A9Bb7JPDzJ visa-qa"
}

