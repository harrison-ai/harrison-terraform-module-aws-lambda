locals {
  default_name = var.name
  dlq_name     = "${var.name}-dlq"
}

resource "aws_sqs_queue" "this" {
  name                       = local.default_name
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = var.max_receive_count
  })

  tags = {
    Name = local.default_name
  }
}

resource "aws_sqs_queue" "dlq" {
  name                       = local.dlq_name
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds

  tags = {
    Name = local.dlq_name
  }
}
