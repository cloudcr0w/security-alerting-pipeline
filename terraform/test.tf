resource "aws_s3_bucket" "test_public_bucket" {
  bucket = "test-public-bucket-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "Test Public Bucket"
    Environment = "dev"
  }

  force_destroy = true
}
