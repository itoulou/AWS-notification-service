variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "notification-system-s3-bucket-terraform"
}

variable "output_lambda_function_zip" {
  description = "S3 key for the Lambda deployment package"
  type        = string
  default     = "notification_lambda.zip"
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}

variable "sqs_queue_url" {
  description = "URL of the SQS queue"
  type        = string
}