output "sns_topic_arn" {
  value = module.sns.sns_topic_arn
}

output "sqs_queue_url" {
  value = module.sqs.sqs_queue_url
}

output "lambda_function_arn" {
  value = module.lambda.lambda_function_arn
}