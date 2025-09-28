resource "aws_route53_zone" "main" {
  count = var.only_recods ? 0 : 1
  name = var.zone_domain_name
}

data "aws_route53_zone" "datazone" {
  count = var.only_recods ? 1 : 0
  name = var.zone_domain_name  
}

resource "aws_route53_record" "dynamic_records" {
  for_each = var.records

  zone_id = var.only_recods ? data.aws_route53_zone.datazone[0].zone_id : aws_route53_zone.main[0].zone_id
  name    = "${each.value.sub_domain}.${var.zone_domain_name}"
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records
}