# IAM Policy
resource "aws_iam_policy" "policy" {
  name = "DisturbanceFreeCallingPolicy"
  description = "My test policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "logs:CreateLogGroup",
        "Resource": "arn:aws:logs::${data.aws_caller_identity.current.account_id}:*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs::${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/DisturbanceFreeCallingLambda:*"
      },
      {
        "Effect": "Allow",
        "Action": "iot:Publish",
        "Resource": "arn:aws:iot::${data.aws_caller_identity.current.account_id}:topic/*"
      }
    ]
  })

  tags = {
    project = "disturbance-free-calling"
  }
}

# IAM Role
resource "aws_iam_role" "role" {
  name = "DisturbanceFreeCallingRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    project = "disturbance-free-calling"
  }
}

# Attach IAM Role and IAM Policy
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

# Lambda Function
resource "aws_lambda_function" "test_lambda" {
  function_name = "DisturbanceFreeCallingLambda"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.role.arn
  filename      = "deployment.zip"

  tags = {
    project = "disturbance-free-calling"
  }
}