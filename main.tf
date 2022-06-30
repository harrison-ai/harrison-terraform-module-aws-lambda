# locals {
#   sqs_is_event_source = var.sqs_queue_name == null && var.sqs_queue_arn == null ? false : true
#   sqs_use_module      = local.sqs_is_event_source == true && var.sqs_queue_name != null ? true : false
# }

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

resource "aws_lambda_event_source_mapping" "this" {
  event_source_arn                   = var.event_source_arn
  function_name                      = aws_lambda_function.this.function_name
  batch_size                         = var.batch_size
  maximum_batching_window_in_seconds = var.maximum_batching_window_in_seconds
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
