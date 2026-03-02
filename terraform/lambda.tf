############################################
# Lambda packaging 
############################################

data "archive_file" "alert_function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda_src/alert_function"
  output_path = "${path.module}/.artifacts/alert_function.zip"
}

data "archive_file" "guardduty_alert_function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda_src/guardduty_alert_function"
  output_path = "${path.module}/.artifacts/guardduty_alert_function.zip"
}

data "archive_file" "aws_config_handler_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda_src/aws_config_handler"
  output_path = "${path.module}/.artifacts/aws_config_handler.zip"
}

data "archive_file" "slack_alert_forwarder_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda_src/slack_alert_forwarder"
  output_path = "${path.module}/.artifacts/slack_alert_forwarder.zip"
}

############################################
# Lambda: Security alert function -> SNS
############################################

resource "aws_lambda_function" "alert_function" {
  function_name = "security-alert-function"
  role          = aws_iam_role.lambda_exec_role_v2.arn
  handler       = "alert_function.lambda_handler"
  runtime       = "python3.12"

  filename         = data.archive_file.alert_function_zip.output_path
  source_code_hash = data.archive_file.alert_function_zip.output_base64sha256

  memory_size = var.lambda_memory_size
  timeout     = var.lambda_timeout
  tags        = local.common_tags

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.security_alerts.arn
    }
  }
}

############################################
# Lambda: GuardDuty handler -> SNS (+ optional env)
############################################

resource "aws_lambda_function" "guardduty_alert_function" {
  function_name = "guardduty_alert_function"
  role          = aws_iam_role.lambda_exec_role_v2.arn
  handler       = "guardduty_alert_function.lambda_handler"
  runtime       = "python3.12"

  filename         = data.archive_file.guardduty_alert_function_zip.output_path
  source_code_hash = data.archive_file.guardduty_alert_function_zip.output_base64sha256

  memory_size = var.lambda_memory_size
  timeout     = var.lambda_timeout


  environment {
    variables = {
      SNS_TOPIC_ARN     = aws_sns_topic.guardduty_alerts.arn
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }

  # Keeping your explicit tags as in the original file.
  tags = {
    Project     = "SecurityAlertingPipeline"
    Environment = "dev"
  }
}

############################################
# Separate execution role (as in your original file)
############################################

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

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

############################################
# Lambda: AWS Config handler
############################################

resource "aws_lambda_function" "aws_config_handler" {
  function_name = "aws_config_handler"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "aws_config_handler.lambda_handler"
  runtime       = "python3.12"

  filename         = data.archive_file.aws_config_handler_zip.output_path
  source_code_hash = data.archive_file.aws_config_handler_zip.output_base64sha256
}

############################################
# Lambda: Slack alert forwarder
############################################

resource "aws_lambda_function" "slack_alert_forwarder" {
  function_name = "slack_alert_forwarder"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "slack_alert_forwarder.lambda_handler"
  runtime       = "python3.12"

  filename         = data.archive_file.slack_alert_forwarder_zip.output_path
  source_code_hash = data.archive_file.slack_alert_forwarder_zip.output_base64sha256

  memory_size = var.lambda_memory_size
  timeout     = var.lambda_timeout
  tags        = local.common_tags


  environment {
    variables = {}
  }
}