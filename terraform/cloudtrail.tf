#Cloudtrail - basic config

resource "aws_cloudtrail" "security_trail" {
  name                          = "security-trail"
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  tags                          = local.common_tags

}
resource "aws_s3_bucket" "trail_bucket" {
  bucket = "security-alert-pipeline-logs-${random_id.bucket_suffix.hex}"
}
resource "aws_s3_bucket_policy" "trail_bucket_policy" {
  bucket = aws_s3_bucket.trail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action   = "s3:GetBucketAcl",
        Resource = "arn:aws:s3:::${aws_s3_bucket.trail_bucket.id}"
      },
      {
        Sid    = "AWSCloudTrailWrite",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.trail_bucket.id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}