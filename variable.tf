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

variable "s3_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "s3bucket-sjdhjshe878"
}

variable "s3_acl" {
  description = "ACL for the S3 bucket"
  type        = string
  default     = "private"
}

variable "s3_versioning" {
  description = "Enable versioning for the S3 bucket [Enabled Suspended Disabled]"
  type        = string
  default     = "Enabled"
}

variable "s3_index_document" {
  description = "Name of the index document for the S3 website"
  type        = string
  default     = "index.html"
}

variable "s3_error_document" {
  description = "Name of the error document for the S3 website"
  type        = string
  default     = "error.html"
}

variable "s3_routing_rules" {
  description = "Routing rules for the S3 website"
  type        = map(map(string))
  default = {
    rule1 = {
      condition               = "{\"KeyPrefixEquals\": \"docs/\"}"
      replace_key_prefix_with = "documents/"
    }
    rule2 = {
      condition               = "{\"KeyPrefixEquals\": \"images/\"}"
      replace_key_prefix_with = "pictures/"
    }
  }
}

variable "s3_enable_website" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}


variable "ec2_pub_keys" {
  default = "ssh-rsa hjjoZ5/shTpRSSZfGucLhkpV5eyqXx73Px1+8Nr1KkbnWB8M1DEyddjjllll7sntmBCTtCorePY56PQZdH5DR26OhVPmAk0LAV6RDoO968E4KDuGLtcT8gjvXciDV2HTFQKGQ4xMYftavplFTDVRFTF9BjXfApTfU6C5IDByj9zqxTbCnDEmz34vmhOqfGWA6ts8S5UFuH4kL5QAroX3F7YkVXjwfe8Fvch4Q7kWSsdh6jva/dxM+zzzL0sZ+v2yucaZn08UOsz+JSwsC2DkKbAdVdplOS2A9Bb7JPDzJ visa-qa"
}

variable "ec2_ui_ami" {
  default = "ami-0b042fbb12ec6768e"
}

variable "ec2_api_ami" {
  default = "ami-0c663346735bede94"
}

variable "ec2_job_ami" {
  default = "ami-0566b54d51a3ba847"
}

variable "ec2_ui_inst_type" {
  default = "t3.micro"
}

variable "ec2_api_inst_type" {
  default = "m5a.xlarge"
}

variable "ec2_job_inst_type" {
  default = "m5a.2xlarge"
}


variable "linux_bastion_name" {
  default = "linux-bastion"
}
variable "ec2_linux_bastion_ami" {
  default = "ami-04aa00acb1165b32a"
}

variable "ec2_linux_bastion_inst_type" {
  default = "t3.micro"
}

variable "api_name" {
  default = "api"
}
variable "job_name" {
  default = "job"
}

variable "ui_name" {
  default = "job"
}

variable "ui_instance_name" {
  description = "Name of EC2 instance"
  type        = string
  default = "ui-server"
}


variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default = "taya-keypair"
}



variable "redis_name" {
  default = "redis"
}

variable "bastion_server_ip" {
  description = "ID of the bastion security group"
  type        = string
  default     = "172.27.30.80/32"
}




variable "ec2_staging_redis_name" {
  type    = string
  default = "staging-redis"
}

variable "ec2_staging_redis_ami" {
  type    = string
  default = "ami-04aa00acb1165b32a"
}

variable "ec2_staging_redis_inst_type" {
  type    = string
  default = "t3.medium"
}

variable "ec2_sftp_server_name" {
  type    = string
  default = "sftp-server"
}

variable "ec2_sftp_server_ami" {
  type    = string
  default = "ami-04aa00acb1165b32a"
}

variable "ec2_sftp_server_inst_type" {
  type    = string
  default = "t3.medium"
}

variable "ec2_tunnel_lb_name" {
  type    = string
  default = "tunnel-lb"
}

variable "ec2_tunnel_lb_ami" {
  type    = string
  default = "ami-04aa00acb1165b32a"
}

variable "ec2_tunnel_lb_inst_type" {
  type    = string
  default = "c5.xlarge"
}
variable "secretManagerName" {
  default = "devops"
}


