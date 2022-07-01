output "queue_arn" {
  description = "Queue arn."
  value = aws_sqs_queue.queue[0].arn
}

output "queue_url" {
  description = "Queue url."
  value = aws_sqs_queue.queue[0].url
}

output "dl_queue_arn" {
  description = "Dead letter queue arn."
  value = aws_sqs_queue.dlqueue[0].arn
}

output "dl_queue_url" {
  description = "Dead letter queue url."
  value = aws_sqs_queue.dlqueue[0].url
}
