variable "app_name" {
  description = "The environment of the application"
  type        = string
  default     = "terraform-delight"
}

variable "app_env" {
  description = "The environment of the application"
  type        = string
  default     = "local"
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "aws_s3_bucket" {
  description = "The name of the AWS S3 bucket"
  type        = string
}

variable "api_gateway_name" {
  description = "The name of the API Gateway"
  type        = string
  default     = "test-api-gateway"
}

variable "test_path" {
  description = "The path of the test endpoint"
  type        = string
  default     = "test"
}
