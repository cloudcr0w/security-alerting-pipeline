variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "alert_email" {
  description = "Email address to receive security alerts"
  type        = string
}
