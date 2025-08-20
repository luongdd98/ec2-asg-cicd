variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "compute_platform" {
  description = "Compute platform for CodeDeploy"
  type        = string
  default     = "Server"
}

variable "service_role_arn" {
  description = "ARN of the service role for CodeDeploy"
  type        = string
}

variable "deployment_config_name" {
  description = "Deployment configuration name"
  type        = string
  default     = "CodeDeployDefault.AllAtOnce"
}

variable "auto_scaling_groups" {
  description = "List of Auto Scaling Group names"
  type        = list(string)
  default     = []
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
  default     = ""
}

variable "auto_rollback_enabled" {
  description = "Enable auto rollback"
  type        = bool
  default     = true
}

variable "auto_rollback_events" {
  description = "Events that trigger auto rollback"
  type        = list(string)
  default     = ["DEPLOYMENT_FAILURE"]
}

variable "alarm_configuration" {
  description = "Alarm configuration for deployment"
  type = object({
    alarms  = list(string)
    enabled = bool
  })
  default = {
    alarms  = []
    enabled = false
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
