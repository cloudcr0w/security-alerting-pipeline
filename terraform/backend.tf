terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "security-alerting-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}