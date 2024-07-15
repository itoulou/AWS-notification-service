resource "aws_lambda_function" "this_lambda" {
  function_name    = "notification-system-lambda-terraform"
  role             = aws_iam_role.lambda_iam_role.arn
  filename         = var.output_lambda_function_zip
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  handler          = "notification_lambda.lambda_handler"
  runtime          = "python3.12"

  environment {
    variables = {
      SQS_QUEUE_URL = var.sqs_queue_url
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
}

data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_file = "${path.module}/code/notification_lambda.py"
  output_path = var.output_lambda_function_zip
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name
  tags = {
    Name = "lambda bucket create via Terraform"
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.bucket.id}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.this_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda_iam_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_iam_role_policy" {
  name = "lambda_iam_role_policy"
  role = aws_iam_role.lambda_iam_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "sqs:SendMessage",
          "sns:Publish"
        ],
        Resource = "*"
      }
    ]
  })
}

output "lambda_function_arn" {
  value = aws_lambda_function.this_lambda.arn
}