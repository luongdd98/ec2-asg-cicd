# IAM Module (cần tạo sau khi có S3 và CodePipeline)
module "iam" {
  source = "../../../modules/aws-iam"

  project_name                      = var.project_name
  s3_bucket_arn                     = module.s3.source_bucket_arn
  codepipeline_artifacts_bucket_arn = module.s3.codepipeline_artifacts_bucket_arn
  codepipeline_arn                  = module.codepipeline.pipeline_arn
  tags                              = local.common_tags
}
