locals {
  sqs_dlqueue_name = var.sqs_queue_name == null ? null : "${var.sqs_queue_name}-dl"
  use_sqs_as_event_source = var.use_sqs_as_event_source && ( var.sqs_queue_name != null || var.sqs_queue_arn != null )
  create_sqs_queues = local.use_sqs_as_event_source && var.sqs_queue_name != null
}

##  -----  Function  -----  ##
resource "aws_lambda_function" "this" {
  function_name = var.name
  description   = var.description
  role          = aws_iam_role.this.arn
  architectures = var.architectures

  ephemeral_storage {
    size = var.ephemeral_storage_size
  }

  image_config {
    command     = var.command
    entry_point = var.entry_point
  }
  image_uri    = var.image_uri
  memory_size  = var.memory_size
  package_type = "Image"
  timeout      = var.timeout

  dynamic "environment" {
    for_each = length(keys(var.envvars)) == 0 ? [] : [true]

    content {
      variables = var.envvars
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_mode == null ? [] : [true]

    content {
      mode = var.tracing_mode
    }
  }

  tags = {
    Name = var.name
  }

  depends_on = [aws_cloudwatch_log_group.this]

  lifecycle {
    ignore_changes = [reserved_concurrent_executions]
  }

}

##  -----  Queues   -----  ##
resource "aws_lambda_event_source_mapping" "this" {
  count                              = local.use_sqs_as_event_source ? 1 : 0
  event_source_arn                   = local.create_sqs_queues ? aws_sqs_queue.queue[0].arn : var.sqs_queue_arn
  function_name                      = aws_lambda_function.this.function_name
  batch_size                         = var.batch_size
  maximum_batching_window_in_seconds = var.maximum_batching_window_in_seconds
}

resource "aws_sqs_queue" "queue" {
  count                      = local.create_sqs_queues ? 1 : 0
  name                       = var.sqs_queue_name
  max_message_size           = var.sqs_max_message_size
  message_retention_seconds  = var.sqs_message_retention_seconds
  receive_wait_time_seconds  = var.sqs_receive_wait_time_seconds
  visibility_timeout_seconds = var.sqs_visibility_timeout_seconds
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlqueue[0].arn
    maxReceiveCount     = var.sqs_max_receive_count
  })
  sqs_managed_sse_enabled = var.sqs_encryption_enabled

  tags = {
    Name = var.sqs_queue_name
  }
}

resource "aws_sqs_queue" "dlqueue" {
  count                      = local.create_sqs_queues ? 1 : 0
  name                       = local.sqs_dlqueue_name
  max_message_size           = var.sqs_max_message_size
  message_retention_seconds  = var.sqs_message_retention_seconds
  receive_wait_time_seconds  = var.sqs_receive_wait_time_seconds
  visibility_timeout_seconds = var.sqs_visibility_timeout_seconds
  sqs_managed_sse_enabled    = var.sqs_encryption_enabled

  tags = {
    Name = local.sqs_dlqueue_name
  }
}

##  -----  IAM   -----  ##
resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = merge(var.iam_abac_tags, { Name = var.name })
}

resource "aws_iam_policy" "this" {

  name   = var.name
  policy = var.lambda_policy

  tags = {
    Name = var.name
  }
}

resource "aws_iam_role_policy_attachment" "aws_managed_sqs_execution" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}


resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

##  -----  CloudWatch  -----  ##
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.cloudwatch_retention_in_days

  tags = {
    Name = var.name
  }
}
