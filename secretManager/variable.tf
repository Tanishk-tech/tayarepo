variable "sm_name" {
  description = "Name of the secret"
  type        = string
}

variable "kms_id" {
  description = "kms ID"
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to the secret"
  type        = map(string)
}