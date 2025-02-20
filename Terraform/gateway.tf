# API Gateway
resource "aws_apigatewayv2_api" "gateway" {
  name          = "DisturbanceFreeCallingGateway"
  protocol_type = "HTTP"
}

# API Gateway Integration
resource "aws_apigatewayv2_integration" "integration" {
  api_id               = aws_apigatewayv2_api.gateway.id
  integration_type     = "AWS_PROXY"
  integration_uri      = aws_lambda_function.lambda.arn
  integration_method   = "GET"
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
  name = "development"
  auto_deploy = true
}

# Output for API Gateway Invoke URL
output "api_invoke_url" {
  value = aws_apigatewayv2_stage.default_stage.invoke_url
  description = "The invoke URL for the deployed API Gateway"
}