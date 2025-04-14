# EventBridge rule that triggers when an IAM user is created
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

# Target: alert Lambda triggered by the IAM CreateUser rule
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.iam_create_user.name
  target_id = "LambdaFunction"
  arn       = aws_lambda_function.alert_function.arn
}

# Allow EventBridge to trigger the Lambda function for CreateUser event
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.alert_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.iam_create_user.arn
}

# EventBridge rule that detects root login without MFA
resource "aws_cloudwatch_event_rule" "root_login" {
  name        = "root-login-alert"
  description = "Detect root account login without MFA"
  event_pattern = jsonencode({
    source        = ["aws.signin"],
    "detail-type" = ["AWS Console Sign In via CloudTrail"],
    detail = {
      userIdentity = {
        type = ["Root"]
      },
      additionalEventData = {
        MFAUsed = ["No"]
      }
    }
  })

  tags = local.common_tags
}

# Target: alert Lambda triggered by root login without MFA
resource "aws_cloudwatch_event_target" "root_login_lambda_target" {
  rule      = aws_cloudwatch_event_rule.root_login.name
  arn       = aws_lambda_function.alert_function.arn
  target_id = "RootLoginLambda"
}

# Allow EventBridge to trigger the Lambda function for root login rule
resource "aws_lambda_permission" "allow_root_login_event" {
  statement_id  = "AllowExecutionFromRootLoginRule"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.alert_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.root_login.arn
}
