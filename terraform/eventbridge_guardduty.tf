# Eventbridge rule to get an event from Guardduty

resource "aws_cloudwatch_event_rule" "guardduty_finding" {
  name        = "guardduty_finding"
  description = "Catches all GuardDuty findings for further alerting"
  event_pattern = jsonencode({
    source      = ["aws.guardduty"],
    detail-type = ["GuardDuty Finding"],
    detail = {
      severity = [{
        numeric = [">=", 5]
      }]
    }
  })
}

resource "aws_cloudwatch_event_target" "guardduty_target" {
  rule = aws_cloudwatch_event_rule.guardduty_finding.name
  arn  = aws_lambda_function.alert_function.arn
}

resource "aws_lambda_permission" "permission_for_lambda" {
  function_name = aws_lambda_function.alert_function.function_name
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.guardduty_finding.arn
}

resource "aws_cloudwatch_event_target" "guardduty_alert_function" {
  rule = aws_cloudwatch_event_rule.guardduty_finding.name
  arn  = aws_lambda_function.guardduty_alert_function.arn
}

resource "aws_lambda_permission" "gd_allow_eventbridge" {
  function_name = aws_lambda_function.guardduty_alert_function.function_name
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_target.guardduty_alert_function.arn

}