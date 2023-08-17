variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Domain name for the ACM certificate"
  type        = string
}

variable "route53_domain_name" {
  description = "Route53 domain name for the new zone"
  type        = string
}

