# A Terraform Module to deploy Image based AWS Lambda Functions.

This module attempts to understand its place in the universe and does not attempt to be all things to everyone. If that is what you want, [this](https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest) is what you are after.

This module is opinionated, yet flexible enough to be really useful. Here are some of the opinions it holds:

- It only caters for [container](https://aws.amazon.com/blogs/aws/new-for-aws-lambda-container-image-support/) image based Lambda Functions
- It assumes it will be triggered by an SQS queue
- It does not support features that we don't envisage using, such as:
  - EFS
  - VPC
  - KMS Encryption of Environment Variables
  - Layers (by virtue of only supporting Container Image based funcctions)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_queues"></a> [queues](#module\_queues) | ./modules/sqs | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aws_managed_sqs_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_event_source_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_iam_policy_document.lambda_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architectures"></a> [architectures](#input\_architectures) | n/a | `list(string)` | n/a | yes |
| <a name="input_batch_size"></a> [batch\_size](#input\_batch\_size) | n/a | `number` | `10` | no |
| <a name="input_cloudwatch_retention_in_days"></a> [cloudwatch\_retention\_in\_days](#input\_cloudwatch\_retention\_in\_days) | n/a | `number` | `30` | no |
| <a name="input_command"></a> [command](#input\_command) | n/a | `list(string)` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | n/a | yes |
| <a name="input_entry_point"></a> [entry\_point](#input\_entry\_point) | n/a | `list(string)` | `null` | no |
| <a name="input_envvars"></a> [envvars](#input\_envvars) | n/a | `map(string)` | `{}` | no |
| <a name="input_ephemeral_storage_size"></a> [ephemeral\_storage\_size](#input\_ephemeral\_storage\_size) | Amount of ephemeral storage (/tmp) in MB your Lambda Function can use at runtime. Valid value between 512 MB to 10,240 MB (10 GB). | `number` | `412` | no |
| <a name="input_iam_abac_tags"></a> [iam\_abac\_tags](#input\_iam\_abac\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | n/a | `string` | n/a | yes |
| <a name="input_lambda_policy"></a> [lambda\_policy](#input\_lambda\_policy) | n/a | `string` | `null` | no |
| <a name="input_maximum_batching_window_in_seconds"></a> [maximum\_batching\_window\_in\_seconds](#input\_maximum\_batching\_window\_in\_seconds) | n/a | `number` | `30` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_sqs_encryption"></a> [sqs\_encryption](#input\_sqs\_encryption) | n/a | `string` | `null` | no |
| <a name="input_sqs_max_message_size"></a> [sqs\_max\_message\_size](#input\_sqs\_max\_message\_size) | n/a | `number` | `262144` | no |
| <a name="input_sqs_max_receive_count"></a> [sqs\_max\_receive\_count](#input\_sqs\_max\_receive\_count) | n/a | `number` | `10` | no |
| <a name="input_sqs_message_retention_seconds"></a> [sqs\_message\_retention\_seconds](#input\_sqs\_message\_retention\_seconds) | n/a | `number` | `1209600` | no |
| <a name="input_sqs_queue_arn"></a> [sqs\_queue\_arn](#input\_sqs\_queue\_arn) | n/a | `string` | `null` | no |
| <a name="input_sqs_queue_name"></a> [sqs\_queue\_name](#input\_sqs\_queue\_name) | n/a | `string` | `null` | no |
| <a name="input_sqs_receive_wait_time_seconds"></a> [sqs\_receive\_wait\_time\_seconds](#input\_sqs\_receive\_wait\_time\_seconds) | n/a | `number` | `20` | no |
| <a name="input_sqs_visibility_timeout_seconds"></a> [sqs\_visibility\_timeout\_seconds](#input\_sqs\_visibility\_timeout\_seconds) | n/a | `number` | `300` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | n/a | `string` | n/a | yes |
| <a name="input_tracing_mode"></a> [tracing\_mode](#input\_tracing\_mode) | n/a | `string` | `null` | no |

## Outputs

No outputs.

## Who do I talk to?

- Repo owner or admin Carl Hattingh(carl.hattingh@harrison.ai)
- Harrison.ai Data Engineering team

## Contributing

## Credits

This repository was created using the [harrison-ai terraform cookiecutter] template (https://github.com/harrison-ai/cookiecutter-terraform)
