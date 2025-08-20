# CodePipeline Module
module "codepipeline" {
  source = "../../../modules/aws-codepipeline"

  project_name                      = var.project_name
  service_role_arn                  = module.iam.codepipeline_role_arn
  artifact_store_bucket             = module.s3.codepipeline_artifacts_bucket_name
  source_bucket_name                = module.s3.source_bucket_name
  source_object_key                 = "flask-deployment.zip"
  poll_for_source_changes           = false
  codedeploy_application_name       = module.codedeploy.application_name
  codedeploy_deployment_group_name  = module.codedeploy.deployment_group_name
  enable_s3_trigger                 = true
  cloudwatch_event_role_arn         = module.iam.cloudwatch_event_role_arn
  tags                              = local.common_tags
}
