#Lambda function

resource "aws_lambda_function" "alert_function" {
  filename         = "../lambda_src/alert_function/alert_function.zip"
  function_name    = "security-alert-function"
  role             = aws_iam_role.lambda_exec_role_v2.arn
  handler          = "alert_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("../lambda_src/alert_function/alert_function.zip")
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout
  tags             = local.common_tags




  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.security_alerts.arn
    }
  }


}

resource "aws_lambda_function" "guardduty_alert_function" {
  filename         = "../lambda_src/guardduty_alert_function/guardduty_alert_function.zip"
  function_name    = "guardduty_alert_function"
  role             = aws_iam_role.lambda_exec_role_v2.arn
  handler          = "guardduty_alert_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("../lambda_src/guardduty_alert_function/guardduty_alert_function.zip")
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout



  environment {
    variables = {
      SNS_TOPIC_ARN     = aws_sns_topic.guardduty_alerts.arn
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }

  tags = {
    Project     = "SecurityAlertingPipeline"
    Environment = "dev"
  }

}
resource "aws_lambda_function" "aws_config_handler" {
  filename         = "../lambda_src/aws_config_handler/aws_config_handler.zip"
  function_name    = "aws_config_handler"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "aws_config_handler.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("../lambda_src/aws_config_handler/aws_config_handler.zip")
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role_final"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}
# Get AWS Account ID for Secrets Manager ARN
# data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "slack_secret_access" {
  name = "SlackSecretAccessPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = "arn:aws:secretsmanager:us-east-1:${data.aws_caller_identity.current.account_id}:secret:slack/webhook-url*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_slack_secret_access" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.slack_secret_access.arn
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "slack_alert_forwarder" {
  filename         = "../lambda_src/slack_alert_forwarder/slack_alert_forwarder.zip"
  function_name    = "slack_alert_forwarder"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "slack_alert_forwarder.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("../lambda_src/slack_alert_forwarder/slack_alert_forwarder.zip")
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout
  tags             = local.common_tags

  environment {
    variables = {
      # no env
    }
  }
}

