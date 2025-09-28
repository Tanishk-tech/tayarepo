variable "s3_name" {
  description = "Name of the S3 bucket"
  type        = string
  default = "s3bucket-sjdhjshe878"
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

variable "s3_enable_website" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "folders" {
  type    = set(string)
  default = []
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
  type        = map(object({
    condition              = string
    replace_key_prefix_with = string
  }))
  default     = {
    rule1 = {
      condition              = "KeyPrefixEquals = 'docs/'"
      replace_key_prefix_with = "documents/"
    }
    rule2 = {
      condition              = "KeyPrefixEquals = 'images/'"
      replace_key_prefix_with = "pictures/"
    }
  }
}


variable "common_tags" {
    type = map(string)
    default = {
        env     = "development"
        team    = "devops"
        purpose = "general"
        proj    = "test"
    }
}

