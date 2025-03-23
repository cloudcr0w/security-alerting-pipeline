#Cloudtrail - basic config

resource "aws_cloudtrail" "security_trail" {
  name                          = "security-trail"
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
}
resource "aws_s3_bucket" "trail_bucket" {
  bucket = "my-security-trail-logs-bucket-for-exercise"
}