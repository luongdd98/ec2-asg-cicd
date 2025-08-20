# CodePipeline
resource "aws_codepipeline" "main" {
  name     = var.project_name
  role_arn = var.service_role_arn

  artifact_store {
    location = var.artifact_store_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        S3Bucket             = var.source_bucket_name
        S3ObjectKey          = var.source_object_key
        PollForSourceChanges = var.poll_for_source_changes
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ApplicationName     = var.codedeploy_application_name
        DeploymentGroupName = var.codedeploy_deployment_group_name
      }
    }
  }

  tags = var.tags
}

# CloudWatch Event Rule để trigger pipeline khi có object mới trong S3
resource "aws_cloudwatch_event_rule" "s3_object_created" {
  count       = var.enable_s3_trigger ? 1 : 0
  name        = "${var.project_name}-s3-object-created"
  description = "Trigger CodePipeline when new object is created in S3"

  event_pattern = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["Object Created"]
    detail = {
      bucket = {
        name = [var.source_bucket_name]
      }
      object = {
        key = [var.source_object_key]
      }
    }
  })

  tags = var.tags
}

# CloudWatch Event Target
resource "aws_cloudwatch_event_target" "codepipeline" {
  count     = var.enable_s3_trigger ? 1 : 0
  rule      = aws_cloudwatch_event_rule.s3_object_created[0].name
  target_id = "TriggerCodePipeline"
  arn       = aws_codepipeline.main.arn
  role_arn  = var.cloudwatch_event_role_arn
}
