resource "aws_s3_bucket" "test_public_bucket" {
  bucket = "test-public-bucket-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "Test Public Bucket"
    Environment = "dev"
  }

  force_destroy = true
}
resource "aws_s3_bucket_acl" "test_public_bucket_acl" {
  bucket = aws_s3_bucket.test_public_bucket.id
  acl    = "public-read"
}