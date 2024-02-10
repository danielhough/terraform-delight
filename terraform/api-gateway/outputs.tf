output "api_gateway_arn" {
  value = aws_api_gateway_rest_api.api.arn
}

output "authorizer_arn" {
  value = aws_api_gateway_authorizer.authorizer.arn
}

output "test_url" {
  value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.aws_region}.amazonaws.com/${var.test_path}"
}
