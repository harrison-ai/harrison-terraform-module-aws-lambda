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

# Sample Lambda function using the module
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
  envvars = {
    FOO = "bar"
  }
  lambda_policy          = data.aws_iam_policy_document.lambda_policy.json
  ephemeral_storage_size = 512
  tracing_mode           = "Active"
  iam_abac_tags = {
    Project = local.project
  }

  # Optional event source SQS queue to create
  sqs_queue_name = "${local.project}-queue-${local.env_name}"

  # Optional event source SQS queue that already exists
  # sqs_queue_arn                = "..."

  # Optional params for new queue:
  sqs_max_message_size           = 262144
  sqs_message_retention_seconds  = 1209600
  sqs_receive_wait_time_seconds  = 20
  sqs_visibility_timeout_seconds = 300
  sqs_encryption_enabled         = true
  sqs_max_receive_count          = 10

}
