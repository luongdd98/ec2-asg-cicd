variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket for source code"
  type        = string
}

variable "codepipeline_artifacts_bucket_arn" {
  description = "ARN of the S3 bucket for CodePipeline artifacts"
  type        = string
}

variable "codepipeline_arn" {
  description = "ARN of the CodePipeline"
  type        = string
}
