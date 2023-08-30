output "lambda_function_externalqueue_arn" {
  value = module.lambda_function_externalqueue.lambda_function_arn
}
output "lambda_function_noqueue_arn" {
  value = module.lambda_function_noqueue.lambda_function_arn
}
output "lambda_function_withqueue_arn" {
  value = module.lambda_function_withqueue.lambda_function_arn
}
