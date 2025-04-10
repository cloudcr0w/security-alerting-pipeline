# -----------------------------------------------------------------------------
# This file defines GuardDuty detector and EventBridge rules for findings
# -----------------------------------------------------------------------------

resource "aws_guardduty_detector" "main" {
  enable = true
  tags   = local.common_tags


}
