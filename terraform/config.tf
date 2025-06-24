resource "aws_s3_bucket" "config_logs" {
  bucket = "aws-config-logs-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "AWS Config Logs"
    Environment = "security-pipeline"
  }
}
resource "aws_s3_bucket_acl" "config_logs_acl" {
  bucket = aws_s3_bucket.config_logs.id
  acl    = "private"
}

resource "aws_config_configuration_recorder" "main" {
  name     = "default"
  role_arn = aws_iam_role.config.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "main" {
  name           = "default"
  s3_bucket_name = aws_s3_bucket.config_logs.bucket
  depends_on     = [aws_config_configuration_recorder.main]
}

resource "aws_config_configuration_recorder_status" "main" {
  name       = aws_config_configuration_recorder.main.name
  is_enabled = true
}

resource "aws_config_config_rule" "iam_user_no_mfa" {
  name = "iam-user-no-mfa"

  source {
    owner             = "AWS"
    source_identifier = "IAM_USER_NO_MFA"
  }

  scope {
    compliance_resource_types = ["AWS::IAM::User"]
  }
}

resource "aws_iam_role" "config" {
  name = "aws_config_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "config.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "config_policy" {
  role       = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}
resource "aws_config_config_rule" "iam_password_policy" {
  name = "iam-password-policy"

  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }
}

resource "aws_config_config_rule" "s3_bucket_public_read_prohibited" {
  name = "s3-bucket-public-read-prohibited"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
}

resource "aws_config_config_rule" "root_mfa_enabled" {
  name = "root-account-mfa-enabled"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }

  scope {
    compliance_resource_types = ["AWS::IAM::User"]
  }

  # notification to SNS
  maximum_execution_frequency = "One_Hour"
}
