# Define S3 policies
variable "buckets_readonly" {
  type        = list(string)
  description = "List of S3 buckets for read-only access"
  default = []
}

variable "buckets_write" {
  type        = list(string)
  description = "List of S3 buckets for write access"
    default = []
}