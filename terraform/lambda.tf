#Lambda function

resource "aws_lambda_function" "alert_function" {
  filename         = "../lambda/alert_function.zip"
  function_name    = "security-alert-function"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "alert_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("../lambda/alert_function.zip")
  memory_size = 256
  timeout     = 10


  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.security_alerts.arn
    }
  }
  tags = {
    Project     = "SecurityAlertingPipeline"
    Environment = "dev"
  }

}

resource "aws_lambda_function" "guardduty_alert_function" {
  filename         = "../lambda/guardduty_alert_function.zip"
  function_name    = "guardduty_alert_function"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "guardduty_alert_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("../lambda/guardduty_alert_function.zip")
  memory_size = 256
  timeout     = 10


  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.security_alerts.arn
    }
  }
  tags = {
    Project     = "SecurityAlertingPipeline"
    Environment = "dev"
  }

}