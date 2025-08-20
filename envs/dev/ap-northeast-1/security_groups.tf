# Security Groups Module
module "security_groups" {
  source = "../../../modules/aws-security-groups"

  project_name = var.project_name
  vpc_id       = data.aws_vpc.main.id
  app_port     = var.app_port
  tags         = local.common_tags
}
