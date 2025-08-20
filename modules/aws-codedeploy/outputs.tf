output "application_name" {
  description = "Name of the CodeDeploy application"
  value       = aws_codedeploy_app.main.name
}

output "deployment_group_name" {
  description = "Name of the CodeDeploy deployment group"
  value       = aws_codedeploy_deployment_group.main.deployment_group_name
}

output "application_id" {
  description = "ID of the CodeDeploy application"
  value       = aws_codedeploy_app.main.id
}
