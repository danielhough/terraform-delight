locals {
  app_pool_name   = "${var.app_name}-${var.cognito_pool_name}-${var.app_env}"
  app_client_name = "${var.app_name}-${var.cognito_client_name}-${var.app_env}"
}
