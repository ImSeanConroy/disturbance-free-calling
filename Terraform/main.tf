/*
Name: IaC Buildout for Disturance Free Calling
Description: AWS Infrastruture Buildout
Project: Disturance Free Calling
*/

# Configure the AWS Provider
provider "aws" {
  default_tags {
    tags = {
      Project     = "Disturbance-Free-Calling"
      Provisioned = "Terraform"
      Environment = "Development"
    }
  }
}

# AWS Account ID
data "aws_caller_identity" "current" {}

# AWS Region
data "aws_region" "current" {}

# === IoT Cloud Configuration ===

# IoT Thing
resource "aws_iot_thing" "device" {
  name = "DisturbanceFreeCallingDevice"
  attributes = {
    Project = "Disturbance-Free-Calling"
    Model   = "Development-ESP32"
  }
}

# IoT Policy
resource "aws_iot_policy" "policy" {
  name = "DisturbanceFreeCallingPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "iot:Connect",
        Resource = "arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:client/DisturbanceFreeCallingDevice"
      },
      {
        Effect   = "Allow",
        Action   = "iot:Subscribe",
        Resource = "arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:topicfilter/disturbance-free-calling/sub"
      },
      {
        Effect   = "Allow",
        Action   = "iot:Receive",
        Resource = "arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:topic/disturbance-free-calling/sub"
      }
    ]
  })
}

# IoT Certificate
resource "aws_iot_certificate" "certificate" {
  active = true
}

# Attach IoT Policy and IoT Certificate
resource "aws_iot_policy_attachment" "policy_certificate_attachment" {
  policy = aws_iot_policy.policy.name
  target = aws_iot_certificate.certificate.arn
}

# Attach IoT Thing and IoT Certificate
resource "aws_iot_thing_principal_attachment" "device_certificate_attachment" {
  principal = aws_iot_certificate.certificate.arn
  thing     = aws_iot_thing.device.name
}

# === Gateway Configuration ===

# API Gateway
resource "aws_apigatewayv2_api" "gateway" {
  name          = "DisturbanceFreeCallingGateway"
  protocol_type = "HTTP"
}

# API Gateway Integration
resource "aws_apigatewayv2_integration" "integration" {
  api_id                 = aws_apigatewayv2_api.gateway.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.lambda.arn
  integration_method     = "GET"
  payload_format_version = "2.0"
}

# Lambda Permission
resource "aws_lambda_permission" "permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.gateway.execution_arn}/*/*"
}

# API Gateway Route
resource "aws_apigatewayv2_route" "post_route" {
  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "POST /"
  target    = "integrations/${aws_apigatewayv2_integration.integration.id}"
}

# API Gateway Stage
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.gateway.id
  name        = "development"
  auto_deploy = true
}

# Output for API Gateway Invoke URL
output "api_invoke_url" {
  value       = aws_apigatewayv2_stage.default_stage.invoke_url
  description = "The invoke URL for the deployed API Gateway"
}

# === S3 Configuration ===

resource "random_uuid" "uuid" {}

# S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "imseanconroy-disturbance-free-calling-${random_uuid.uuid.result}"
}

# S3 Bucket Object
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "deployment"
  source = "./deployment.zip"
}

# === Lambda Configuration ===

# IAM Policy
resource "aws_iam_policy" "policy" {
  name        = "DisturbanceFreeCallingPolicy"
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
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.log.name}:*"
      },
      {
        Effect   = "Allow",
        Action   = "iot:Publish",
        Resource = "arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:topic/*"
      },
      {
        Effect   = "Allow",
        Action   = "iot:Connect",
        Resource = "arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:client/${aws_iot_thing.device.name}"
      },
    ]
  })
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
  s3_bucket     = aws_s3_bucket.bucket.id
  s3_key        = aws_s3_object.object.key

  environment {
    variables = {
      AWS_IOT_TOPIC  = "disturbance-free-calling/sub"
      AWS_IOT_REGION = "${data.aws_region.current.name}"
    }
  }
}

# Log Group
resource "aws_cloudwatch_log_group" "log" {
  name = "/aws/lambda/DisturbanceFreeCallingLambda"
}
