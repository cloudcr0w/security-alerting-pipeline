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