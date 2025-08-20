variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "service_role_arn" {
  description = "ARN of the service role for CodePipeline"
  type        = string
}

variable "artifact_store_bucket" {
  description = "S3 bucket for storing pipeline artifacts"
  type        = string
}

variable "source_bucket_name" {
  description = "S3 bucket name for source code"
  type        = string
}

variable "source_object_key" {
  description = "S3 object key for source code"
  type        = string
  default     = "source.zip"
}

variable "poll_for_source_changes" {
  description = "Whether to poll for source changes"
  type        = bool
  default     = false
}

variable "codedeploy_application_name" {
  description = "Name of the CodeDeploy application"
  type        = string
}

variable "codedeploy_deployment_group_name" {
  description = "Name of the CodeDeploy deployment group"
  type        = string
}

variable "enable_s3_trigger" {
  description = "Enable S3 trigger for pipeline"
  type        = bool
  default     = true
}

variable "cloudwatch_event_role_arn" {
  description = "ARN of the CloudWatch Events role"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
