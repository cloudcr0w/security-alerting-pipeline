# Log group for IAM alert Lambda
resource "aws_cloudwatch_log_group" "iam_alert_logs" {
  name              = "/aws/lambda/security-alert-function"
  retention_in_days = 7
  tags              = local.common_tags
}

# CloudWatch alarm for Lambda errors
resource "aws_cloudwatch_metric_alarm" "iam_alert_errors" {
  alarm_name          = "iam_alert_lambda_errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Triggers if IAM alert Lambda has any errors"
  dimensions = {
    FunctionName = aws_lambda_function.alert_function.function_name
  }

  alarm_actions = [aws_sns_topic.security_alerts.arn]

  tags = local.common_tags
}

resource "aws_cloudwatch_log_metric_filter" "lambda_errors" {
  name           = "LambdaErrorCount"
  log_group_name = "/aws/lambda/security-alert-function"
  pattern        = "?ERROR ?Exception"

  metric_transformation {
    name      = "LambdaErrorCount"
    namespace = "Custom/Lambda"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "lambda_throttles" {
  name           = "LambdaThrottleCount"
  log_group_name = "/aws/lambda/security-alert-function"
  pattern        = "Task timed out"

  metric_transformation {
    name      = "LambdaThrottleCount"
    namespace = "Custom/Lambda"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name          = "LambdaErrorAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "LambdaErrorCount"
  namespace           = "Custom/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when Lambda errors occur"
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "lambda_throttle_alarm" {
  alarm_name          = "LambdaThrottleAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "LambdaThrottleCount"
  namespace           = "Custom/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when Lambda throttling occurs"
  treat_missing_data  = "notBreaching"
}
