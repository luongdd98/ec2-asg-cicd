# S3 Module
module "s3" {
  source = "../../../modules/aws-s3"

  project_name           = var.project_name
  enable_s3_notification = true
  tags                   = local.common_tags
}
