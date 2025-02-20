# IAM Policy
resource "aws_iam_policy" "policy" {
  name = "DisturbanceFreeCallingPolicy"
  description = "Disturbance Free Calling Policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:eu-central-1:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.log.name}:*"
      },
      {
        Effect = "Allow",
        Action = "iot:Publish",
        Resource = "arn:aws:iot:eu-central-1:${data.aws_caller_identity.current.account_id}:topic/*"
      },
      {
        Effect = "Allow",
        Action = "iot:Connect",
        Resource = "arn:aws:iot:eu-central-1:${data.aws_caller_identity.current.account_id}:client/${aws_iot_thing.device.name}"
      },
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
        Effect = "Allow",
        Action = "sts:AssumeRole",
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
resource "aws_lambda_function" "lambda" {
  function_name = "DisturbanceFreeCallingLambda"
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  role          = aws_iam_role.role.arn
  s3_bucket = aws_s3_bucket.bucket.id
  s3_key = aws_s3_object.object.key

  environment {
    variables = {
      AWS_IOT_TOPIC  = "disturbance-free-calling/sub"
      AWS_IOT_REGION = "eu-central-1"
    }
  }

  tags = {
    project = "disturbance-free-calling"
  }
}

# Log Group
resource "aws_cloudwatch_log_group" "log" {
  name = "/aws/lambda/DisturbanceFreeCallingLambda"

  tags = {
    Project = "Disturbance-Free-Calling"
  }
}
