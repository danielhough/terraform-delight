terraform {
  backend "s3" {
    encrypt = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# retrieve previous states

data "terraform_remote_state" "cognito" {
  backend = "s3"
  config = {
    bucket = var.aws_s3_bucket
    key    = "terraform/${var.app_name}-cognito-${var.app_env}.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "lambda" {
  backend = "s3"
  config = {
    bucket = var.aws_s3_bucket
    key    = "terraform/${var.app_name}-lambda-${var.app_env}.tfstate"
    region = var.aws_region
  }
}

data "aws_cognito_user_pools" "existing_cognito" {
  name = data.terraform_remote_state.cognito.outputs.cognito_pool_name
}

data "aws_lambda_function" "existing_lambda" {
  function_name = data.terraform_remote_state.lambda.outputs.lambda_function_name
}

# beginning of api gateway configuration

resource "aws_api_gateway_rest_api" "api" {
  name = local.app_api_gateway_name
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [aws_api_gateway_integration.test_integration]
  rest_api_id = aws_api_gateway_rest_api.api.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = var.app_env
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
}

resource "aws_api_gateway_authorizer" "authorizer" {
  name        = "test_authorizer"
  rest_api_id = aws_api_gateway_rest_api.api.id
  type        = "COGNITO_USER_POOLS"

  provider_arns = [tolist(data.aws_cognito_user_pools.existing_cognito.arns)[0]]
}

# endpoints

resource "aws_api_gateway_resource" "test_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.test_path
}

resource "aws_api_gateway_method" "test_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.test_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.authorizer.id
}

resource "aws_api_gateway_integration" "test_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.test_resource.id
  http_method = aws_api_gateway_method.test_get.http_method

  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = data.aws_lambda_function.existing_lambda.invoke_arn
}
