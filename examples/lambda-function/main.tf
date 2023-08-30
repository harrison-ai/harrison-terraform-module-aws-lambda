# Sample ECR repository for demonstration purposes
# It is expected that this already exists
resource "aws_ecr_repository" "this" {
  name = "${local.project}-ecr-${local.env_name}"
  provisioner "local-exec" {
    command = <<EOT
      docker build -t ${self.repository_url}:latest .
      aws ecr --region ${local.region} get-login-password | \
        docker login --username AWS --password-stdin ${self.repository_url}
      docker push ${self.repository_url}:latest
    EOT
  }
}

# Sample Lambda function using the module that includes default SQS queues
module "lambda_function_withqueue" {
  source = "../../"

  depends_on    = [aws_ecr_repository.this]
  architectures = ["x86_64"]
  name          = "${local.project}-withqueue-${local.env_name}"
  description   = "Example Lambda Function"
  image_uri     = "${aws_ecr_repository.this.repository_url}:latest"
  memory_size   = 128
  timeout       = 10
  #  Optional params
  entry_point                        = ["/lambda-entrypoint.sh"]
  command                            = ["app.handler"]
  batch_size                         = 1
  maximum_batching_window_in_seconds = 30
  cloudwatch_retention_in_days       = 7
  envvars = {
    FOO = "bar"
  }
  lambda_policy          = data.aws_iam_policy_document.lambda_policy.json
  ephemeral_storage_size = 512
  tracing_mode           = "Active"
  iam_abac_tags = {
    Project = local.project
  }

  # The default is true
  # use_sqs_as_event_source = true
  sqs_queue_name = "${local.project}-withqueue-${local.env_name}-queue"
}

# Sample Lambda function using the module that does not include SQS queues
module "lambda_function_noqueue" {
  source = "../../"

  depends_on    = [aws_ecr_repository.this]
  architectures = ["x86_64"]
  name          = "${local.project}-noqueue-${local.env_name}"
  description   = "Example Lambda Function"
  image_uri     = "${aws_ecr_repository.this.repository_url}:latest"
  memory_size   = 128
  timeout       = 10
  #  Optional params
  entry_point                        = ["/lambda-entrypoint.sh"]
  command                            = ["app.handler"]
  batch_size                         = 1
  maximum_batching_window_in_seconds = 30
  cloudwatch_retention_in_days       = 7
  envvars = {
    FOO = "bar"
  }
  lambda_policy          = data.aws_iam_policy_document.lambda_policy.json
  ephemeral_storage_size = 512
  tracing_mode           = "Active"
  iam_abac_tags = {
    Project = local.project
  }

  # This can be unset as the module does further detection
  # use_sqs_as_event_source = false
}

# Sample Lambda function using the module but providing your own SQS queue
module "lambda_function_externalqueue" {
  source = "../../"

  depends_on    = [aws_ecr_repository.this]
  architectures = ["x86_64"]
  name          = "${local.project}-externalqueue-${local.env_name}"
  description   = "Example Lambda Function"
  image_uri     = "${aws_ecr_repository.this.repository_url}:latest"
  memory_size   = 128
  timeout       = 10
  #  Optional params
  entry_point                        = ["/lambda-entrypoint.sh"]
  command                            = ["app.handler"]
  batch_size                         = 1
  maximum_batching_window_in_seconds = 30
  cloudwatch_retention_in_days       = 7
  envvars = {
    FOO = "bar"
  }
  lambda_policy          = data.aws_iam_policy_document.lambda_policy.json
  ephemeral_storage_size = 512
  tracing_mode           = "Active"
  iam_abac_tags = {
    Project = local.project
  }

  sqs_queue_arn = aws_sqs_queue.external.arn
}

resource "aws_sqs_queue" "external" {
  name = "${local.project}-external-${local.env_name}"
}
