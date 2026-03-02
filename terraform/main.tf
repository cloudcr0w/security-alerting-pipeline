terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.4.0"
    }
  }
}
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

provider "aws" {
  region = var.region
}

