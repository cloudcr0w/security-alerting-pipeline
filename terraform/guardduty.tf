# GuardDuty detector

resource "aws_guardduty_detector" "main" {
  enable = true
  tags = {
    Environment = "dev"
    Project     = "SecurityAlertingPipeline"
  }

}
