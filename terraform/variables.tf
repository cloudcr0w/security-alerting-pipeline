variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "alert_email" {
  description = "Email address to receive security alerts"
  type        = string
}
variable "lambda_timeout" {
  description = "Maximum execution time for Lambda in seconds"
  type        = number
  default     = 10
}

variable "lambda_memory_size" {
  description = "Amount of memory in MB for Lambda"
  type        = number
  default     = 256
}
variable "slack_webhook_url" {
  description = "Slack incoming webhook URL"
  sensitive   = true
}

variable "cloudtrail_log_group_name" {
  description = "Name of the CloudTrail log group"
  type        = string
  default     = "/aws/cloudtrail/my-cloudtrail-log-group" 
}
