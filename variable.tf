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