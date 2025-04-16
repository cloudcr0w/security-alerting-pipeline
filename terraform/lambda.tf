#Lambda function

resource "aws_lambda_function" "alert_function" {
  filename         = "../lambda/alert_function.zip"
  function_name    = "security-alert-function"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "alert_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("../lambda/alert_function.zip")
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout



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
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout



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
resource "aws_lambda_function" "aws_config_handler" {
  filename         = "lambda/aws_config_handler.zip"
  function_name    = "aws_config_handler"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "aws_config_handler.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("lambda/aws_config_handler.zip")
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
