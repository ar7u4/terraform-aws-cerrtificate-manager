provider "aws" {
  region = var.region
}

resource "aws_acm_certificate" "main" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "main" {
  name = var.route53_domain_name
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for opt in aws_acm_certificate.main.domain_validation_options : opt.resource_record_name]
}

resource "aws_route53_record" "acm_validation" {
  count   = length(aws_acm_certificate.main.domain_validation_options)
  zone_id = aws_route53_zone.main.zone_id
  name    = element(aws_acm_certificate.main.domain_validation_options.*.resource_record_name, count.index)
  type    = element(aws_acm_certificate.main.domain_validation_options.*.resource_record_type, count.index)
  ttl     = 300
  records = [element(aws_acm_certificate.main.domain_validation_options.*.resource_record_value, count.index)]
}

