resource "random_id" "bucket_suffix" {
  byte_length = 4
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}