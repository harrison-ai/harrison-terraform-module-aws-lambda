output "queue_arn" {
  value = aws_sqs_queue.queue[0].arn
}

output "queue_url" {
  value = aws_sqs_queue.queue[0].url
}

output "dl_queue_arn" {
  value = aws_sqs_queue.dlqueue[0].arn
}

output "dl_queue_url" {
  value = aws_sqs_queue.dlqueue[0].url
}
