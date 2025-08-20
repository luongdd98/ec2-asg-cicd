# CodeDeploy Module
module "codedeploy" {
  source = "../../../modules/aws-codedeploy"

  project_name           = var.project_name
  service_role_arn       = module.iam.codedeploy_role_arn
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  auto_scaling_groups    = [module.asg.asg_name]
  target_group_name      = module.alb.target_group_name
  auto_rollback_enabled  = true
  auto_rollback_events   = ["DEPLOYMENT_FAILURE"]
  tags                   = local.common_tags
}
