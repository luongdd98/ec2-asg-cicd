output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the load balancer"
  value       = module.alb.alb_zone_id
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for source code"
  value       = module.s3.source_bucket_name
}

output "codedeploy_application_name" {
  description = "Name of the CodeDeploy application"
  value       = module.codedeploy.application_name
}

output "codedeploy_deployment_group_name" {
  description = "Name of the CodeDeploy deployment group"
  value       = module.codedeploy.deployment_group_name
}

output "codepipeline_name" {
  description = "Name of the CodePipeline"
  value       = module.codepipeline.pipeline_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.asg.asg_name
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = data.aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [data.aws_subnet.private_01.id, data.aws_subnet.private_02.id]
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [data.aws_subnet.public_01.id, data.aws_subnet.public_02.id]
}
