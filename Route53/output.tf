output "zone_id" {
  value = var.only_recods ? data.aws_route53_zone.datazone[0].zone_id : aws_route53_zone.main[0].zone_id
}