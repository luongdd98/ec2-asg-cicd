# ACM Module
module "acm" {
  source = "../../../modules/aws-acm"

  domain_name     = var.certificate_domain
  hosted_zone_id  = var.hosted_zone_id
  tags            = local.common_tags
}
