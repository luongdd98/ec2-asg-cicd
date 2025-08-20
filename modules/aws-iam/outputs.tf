output "ec2_instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "codedeploy_role_arn" {
  description = "ARN of the CodeDeploy service role"
  value       = aws_iam_role.codedeploy_role.arn
}

output "codepipeline_role_arn" {
  description = "ARN of the CodePipeline service role"
  value       = aws_iam_role.codepipeline_role.arn
}

output "cloudwatch_event_role_arn" {
  description = "ARN of the CloudWatch Events role"
  value       = aws_iam_role.cloudwatch_event_role.arn
}
