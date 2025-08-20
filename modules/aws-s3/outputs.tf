output "source_bucket_name" {
  description = "Name of the source S3 bucket"
  value       = aws_s3_bucket.source_bucket.bucket
}

output "source_bucket_arn" {
  description = "ARN of the source S3 bucket"
  value       = aws_s3_bucket.source_bucket.arn
}

output "codepipeline_artifacts_bucket_name" {
  description = "Name of the CodePipeline artifacts S3 bucket"
  value       = aws_s3_bucket.codepipeline_artifacts.bucket
}

output "codepipeline_artifacts_bucket_arn" {
  description = "ARN of the CodePipeline artifacts S3 bucket"
  value       = aws_s3_bucket.codepipeline_artifacts.arn
}
