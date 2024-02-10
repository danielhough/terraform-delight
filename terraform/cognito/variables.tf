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

variable "cognito_pool_name" {
  type        = string
  description = "The name of the pool"
  default     = "test-pool"
}

variable "cognito_client_name" {
  type        = string
  description = "The name of the pool client"
  default     = "test-client"
}
