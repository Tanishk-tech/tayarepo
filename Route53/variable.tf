variable "zone_domain_name" {}
variable "records" {
  type        = map(object({
    sub_domain    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
}

variable "only_recods" {}
variable "manual_zone_id" {}