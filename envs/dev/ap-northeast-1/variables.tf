variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = "default"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "will-stag-apn1-flask-python"
}

# VPC and Subnet Configuration
variable "vpc_name" {
  description = "Name of the existing VPC"
  type        = string
  default     = "will-stag-apn1-vpc"
}

variable "private_subnet_01_name" {
  description = "Name of the first private subnet"
  type        = string
  default     = "will-stag-apn1-private-sn-01"
}

variable "private_subnet_02_name" {
  description = "Name of the second private subnet"
  type        = string
  default     = "will-stag-apn1-private-sn-02"
}

variable "public_subnet_01_name" {
  description = "Name of the first public subnet"
  type        = string
  default     = "will-stag-apn1-public-sn-01"
}

variable "public_subnet_02_name" {
  description = "Name of the second public subnet"
  type        = string
  default     = "will-stag-apn1-public-sn-02"
}

# SSL Certificate
variable "certificate_domain" {
  description = "Domain name for SSL certificate"
  type        = string
  default     = "alb-external.eragon123app.com"
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID for DNS validation"
  type        = string
  default     = "Z02465083DJHC4QU28C5X"
}

# Application Configuration
variable "app_port" {
  description = "Application port"
  type        = number
  default     = 5000
}

# EC2 Configuration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}
