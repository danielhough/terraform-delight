output "cognito_pool_name" {
  value = aws_cognito_user_pool.pool.name
}

output "cognito_pool_arn" {
  value = aws_cognito_user_pool.pool.arn
}
