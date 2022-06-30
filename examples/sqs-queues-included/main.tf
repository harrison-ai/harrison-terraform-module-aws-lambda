# Sample ECR repository for demonstration purposes
# It is expected that this already exists
resource "aws_ecr_repository" "this" {
  name = "${local.project}-ecr-${local.env_name}"
  provisioner "local-exec" {
    command = <<EOT
      docker build -t ${self.repository_url}:latest .
      aws ecr --profile ${local.profile} --region ${local.region} get-login-password | \
        docker login --username AWS --password-stdin ${self.repository_url}
      docker push ${self.repository_url}:latest
    EOT
  }
}



#  Example where SQS queues are deployed with the Lambda function

module "lambda_function" {
  source = "../../"

  depends_on    = [aws_ecr_repository.this]
  architectures = ["x86_64"]
  name          = "${local.project}-function-${local.env_name}"
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
  
  event_source_arn = module.queues.queue_arn
  
  envvars = {
    FOO = "bar"
  }
  lambda_policy          = data.aws_iam_policy_document.lambda_policy.json
  ephemeral_storage_size = 512
  tracing_mode           = "Active"
  iam_abac_tags = {
    Project = local.project
  }

}

module "queues" {
  source = "../../modules/sqs"

  name = "${local.project}-function-${local.env_name}"
  #  add remaining attributes
}

#  End example where SQS queues are deployed with the Lambda function



#  Example where SQS queues pre-exist

module "lambda_function" {
  source = "../../"

  depends_on    = [aws_ecr_repository.this]
  architectures = ["x86_64"]
  name          = "${local.project}-function-${local.env_name}"
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
  
  event_source_arn = data.aws_sqs_queue.selected.arn
  
  envvars = {
    FOO = "bar"
  }
  lambda_policy          = data.aws_iam_policy_document.lambda_policy.json
  ephemeral_storage_size = 512
  tracing_mode           = "Active"
  iam_abac_tags = {
    Project = local.project
  }

}

data "aws_sqs_queue" "selected" {
  name = "foo"
}

#  End example where SQS queues pre-exist
