resource "aws_sqs_queue" "this_sqs_queue" {
  name = "notification-system-queue-terraform"
}

output "sqs_queue_url" {
  value = aws_sqs_queue.this_sqs_queue.id
}