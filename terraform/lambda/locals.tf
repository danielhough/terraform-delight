locals {
  app_lambda_name         = "${var.app_name}-${var.lambda_function_name}-${var.app_env}"
  lambda_source_file_path = "../../bin/${var.lambda_function_name}/main"
  lambda_zip_file_path    = "../../bin/${var.lambda_function_name}/main.zip"
  lambda_role_name        = "${var.app_name}-${var.lambda_function_name}-${var.app_env}-role"
  lambda_policy_name      = "${var.app_name}-${var.lambda_function_name}-${var.app_env}-policy"
}
