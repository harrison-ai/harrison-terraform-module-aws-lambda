output "queue_arn" {
  description = "Queue arn."
  value       = one(aws_sqs_queue.queue[*].arn)
}

output "queue_url" {
  description = "Queue url."
  value       = one(aws_sqs_queue.queue[*].url)
}

output "dl_queue_arn" {
  description = "Dead letter queue arn."
  value       = one(aws_sqs_queue.dlqueue[*].arn)
}

output "dl_queue_url" {
  description = "Dead letter queue url."
  value       = one(aws_sqs_queue.dlqueue[*].url)
}
