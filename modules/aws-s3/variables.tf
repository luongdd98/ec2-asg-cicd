variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "enable_s3_notification" {
  description = "Enable S3 bucket notification for EventBridge"
  type        = bool
  default     = true
}
