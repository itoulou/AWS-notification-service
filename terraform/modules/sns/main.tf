resource "aws_sns_topic" "this_sns_topic" {
  name = "notification-system-topic-terraform"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this_sns_topic.arn
  protocol  = "email"
  endpoint  = var.email_address
}

output "sns_topic_arn" {
  value = aws_sns_topic.this_sns_topic.arn
}