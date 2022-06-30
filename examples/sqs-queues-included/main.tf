resource "aws_ecr_repository" "this" {
  name = "${local.project}-ecr-${local.env_name}"
}

module "lambda_function" {
  source = "../"

  architectures    = "[]"
  name             = "${local.project}-function-${local.env_name}"
  description      = "Example Lambda Function"
  image_uri        = "${aws_ecr_repository.this.repository_url}:latest"
  memory_size      = 128
  timeout          = 10
  event_source_arn = ""
  #  Optional params
  entry_point                        = null
  command                            = null
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
}

module "sqs" {
  source = "../modules/sqs"
}
