provider "aws" {
  region = "us-east-1"
}

# SNS notification

resource "aws_sns_topic" "security_alerts" {
  name = "security_alerts_topic"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = "urbanoadam86@gmail.com"
}

#IAM Role for Lambda Execution

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsondecode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_publish_sns" {
  name = "lambda_publish_sns"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsondecode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow",
      Action   = ["sns:Publish"],
      Resource = aws_sns_topic.security_alerts.arn
    }]
  })

}

#Lambda function

resource "aws_lambda_function" "alert_function" {
  filename         = "../lambda/alert_function.zip"
  function_name    = "security-alert-function"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "alert_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("../lambda/alert_function.zip")

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.security_alerts.arn
    }
  }
}

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

#Eventbridge rule to create user

resource "aws_cloudwatch_event_rule" "iam_create_user" {
  name        = "iam-create-user-rule"
  description = "Trigger on IAM CreateUser events"
  event_pattern = jsonencode({
    source      = ["aws.iam"],
    detail-type = ["AWS API Call via CloudTrail"],
    detail = {
      eventName = ["CreateUser"]
    }
  })
}
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.iam_create_user.name
  target_id = "LambdaFunction"
  arn       = aws_lambda_function.alert_function.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.alert_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.iam_create_user.arn
}