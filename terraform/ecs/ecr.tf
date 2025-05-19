resource "aws_ecr_repository" "alert_receiver" {
  name = "alert-receiver"
  image_tag_mutability = "MUTABLE"

  tags = {
    Project     = "SecurityAlerting"
    Environment = "dev"
  }
}
