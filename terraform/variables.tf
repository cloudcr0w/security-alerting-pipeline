# General settings
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "alert_email" {
  description = "Email address to receive security alerts"
  type        = string
}

# Lambda configuration
variable "lambda_timeout" {
  description = "Maximum execution time for Lambda in seconds"
  type        = number
  default     = 10
  validation {
    condition     = var.lambda_timeout <= 900
    error_message = "Lambda timeout cannot exceed 900 seconds."
  }
}

variable "lambda_memory_size" {
  description = "Amount of memory in MB for Lambda"
  type        = number
  default     = 256
}

# Integrations
variable "slack_webhook_url" {
  description = "Slack incoming webhook URL"
  sensitive   = true
}

# Logging
variable "cloudtrail_log_group_name" {
  description = "Name of the CloudTrail log group"
  type        = string
  default     = "/aws/cloudtrail/my-cloudtrail-log-group"
}
