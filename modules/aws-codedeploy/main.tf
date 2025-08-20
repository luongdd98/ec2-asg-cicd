# CodeDeploy Application
resource "aws_codedeploy_app" "main" {
  compute_platform = var.compute_platform
  name             = var.project_name

  tags = var.tags
}

# CodeDeploy Deployment Group
resource "aws_codedeploy_deployment_group" "main" {
  app_name              = aws_codedeploy_app.main.name
  deployment_group_name = "${var.project_name}-deployment-group"
  service_role_arn      = var.service_role_arn

  deployment_config_name = var.deployment_config_name

  # EC2 Tag Filter for Auto Scaling Groups
  dynamic "ec2_tag_filter" {
    for_each = var.auto_scaling_groups
    content {
      key   = "aws:autoscaling:groupName"
      type  = "KEY_AND_VALUE"
      value = ec2_tag_filter.value
    }
  }

  # Load Balancer Info
  dynamic "load_balancer_info" {
    for_each = var.target_group_name != "" ? [1] : []
    content {
      target_group_info {
        name = var.target_group_name
      }
    }
  }

  # Auto Rollback Configuration
  auto_rollback_configuration {
    enabled = var.auto_rollback_enabled
    events  = var.auto_rollback_events
  }

  # Alarm Configuration
  dynamic "alarm_configuration" {
    for_each = length(var.alarm_configuration) > 0 ? [var.alarm_configuration] : []
    content {
      alarms  = alarm_configuration.value.alarms
      enabled = alarm_configuration.value.enabled
    }
  }

  tags = var.tags
}
