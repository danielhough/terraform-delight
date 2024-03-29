variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "app_env" {
  description = "The environment of the application"
  type        = string
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
