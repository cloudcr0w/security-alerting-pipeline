# -------------------------------------------------------------------
# GuardDuty setup: enables threat detection in the AWS account
# -------------------------------------------------------------------

# Create and enable the GuardDuty detector
resource "aws_guardduty_detector" "main" {
  enable = true

  # Tags for clarity and resource tracking
  tags = local.common_tags
}
