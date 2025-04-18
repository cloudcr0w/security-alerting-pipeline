# IAM Role that allows Lambda to assume execution role
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  # Tags for identification
  tags = local.common_tags
}

# IAM inline policy to allow Lambda to publish alerts to SNS topic
resource "aws_iam_role_policy" "lambda_publish_sns" {
  name = "lambda_publish_sns"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow",
      Action   = ["sns:Publish"],
      Resource = aws_sns_topic.security_alerts.arn
    }]
  })
}

# IAM inline policy to allow Lambda to write logs to CloudWatch Logs
resource "aws_iam_role_policy" "lambda_logging" {
  name = "lambda_logging_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}
