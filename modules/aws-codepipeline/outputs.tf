output "pipeline_name" {
  description = "Name of the CodePipeline"
  value       = aws_codepipeline.main.name
}

output "pipeline_arn" {
  description = "ARN of the CodePipeline"
  value       = aws_codepipeline.main.arn
}

output "pipeline_id" {
  description = "ID of the CodePipeline"
  value       = aws_codepipeline.main.id
}
