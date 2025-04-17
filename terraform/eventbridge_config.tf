resource "aws_cloudwatch_event_rule" "aws_config_compliance_change" {
  name        = "aws-config-compliance-change"
  description = "Catch compliance state changes from AWS Config rules"
  event_pattern = jsonencode({
    "source" : ["aws.config"],
    "detail-type" : ["Config Rules Compliance Change"]
  })
}

resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.aws_config_compliance_change.name
  target_id = "send-to-sns"
  arn       = aws_sns_topic.aws_config_alerts.arn
}

resource "aws_lambda_permission" "allow_eventbridge_to_invoke_lambda" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws_config_handler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.aws_config_compliance_change.arn
}
