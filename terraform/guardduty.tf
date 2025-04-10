# GuardDuty detector

resource "aws_guardduty_detector" "main" {
  enable = true
  tags = local.common_tags


}
