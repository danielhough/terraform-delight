variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "terraform-delight"
}

variable "app_env" {
  description = "The environment of the application"
  type        = string
  default     = "local"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "test-lambda"
}

variable "lambda_runtime" {
  description = "The runtime of the Lambda function"
  type        = string
  default     = "go1.x"
}

variable "lambda_handler" {
  description = "The handler of the Lambda function"
  type        = string
  default     = "main"
}

variable "gateway_id" {
  description = "The ID of the API Gateway"
  type        = string
  default     = "value"
}
