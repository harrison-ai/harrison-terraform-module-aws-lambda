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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.20.1 |

## Modules

No modules.

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
| [aws_sqs_queue.dlqueue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_iam_policy_document.lambda_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Architectures to use. For example x86\_64. | `list(string)` | n/a | yes |
| <a name="input_batch_size"></a> [batch\_size](#input\_batch\_size) | The largest number of records that Lambda will retrieve from the queue at the time of invocation. Defaults to 10 for SQS. | `number` | `10` | no |
| <a name="input_cloudwatch_retention_in_days"></a> [cloudwatch\_retention\_in\_days](#input\_cloudwatch\_retention\_in\_days) | Days to keep Cloudwatch logs before they are deleted. | `number` | `30` | no |
| <a name="input_command"></a> [command](#input\_command) | Command to run in Lambda. This is equivalent to Docker CMD. | `list(string)` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the Lambda. | `string` | n/a | yes |
| <a name="input_entry_point"></a> [entry\_point](#input\_entry\_point) | Entrypoint of Lambda. This is equivalent to Docker ENTRYPOINT. | `list(string)` | `null` | no |
| <a name="input_envvars"></a> [envvars](#input\_envvars) | Map of environment variables for the Lambda function. | `map(string)` | `{}` | no |
| <a name="input_ephemeral_storage_size"></a> [ephemeral\_storage\_size](#input\_ephemeral\_storage\_size) | Amount of ephemeral storage (/tmp) in MB your Lambda Function can use at runtime. Valid value between 512 MB to 10,240 MB (10 GB). | `number` | `512` | no |
| <a name="input_iam_abac_tags"></a> [iam\_abac\_tags](#input\_iam\_abac\_tags) | ABAC tags to pass. See https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction_attribute-based-access-control.html | `map(string)` | `{}` | no |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | Private ECR repository URI. | `string` | n/a | yes |
| <a name="input_lambda_policy"></a> [lambda\_policy](#input\_lambda\_policy) | Additional aws\_iam\_policy resource to include. | `string` | `null` | no |
| <a name="input_maximum_batching_window_in_seconds"></a> [maximum\_batching\_window\_in\_seconds](#input\_maximum\_batching\_window\_in\_seconds) | The maximum amount of time to gather records before invoking the function, in seconds (between 0 and 300). Records will continue to accumulate until either maximum\_batching\_window\_in\_seconds expires or batch\_size has been met. | `number` | `30` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Memory size of the lambda in megabytes. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Lambda. | `string` | n/a | yes |
| <a name="input_sqs_encryption_enabled"></a> [sqs\_encryption\_enabled](#input\_sqs\_encryption\_enabled) | Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys. | `bool` | `false` | no |
| <a name="input_sqs_max_message_size"></a> [sqs\_max\_message\_size](#input\_sqs\_max\_message\_size) | The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB). The default for this attribute is 262144 (256 KiB) | `number` | `262144` | no |
| <a name="input_sqs_max_receive_count"></a> [sqs\_max\_receive\_count](#input\_sqs\_max\_receive\_count) | The number of times a message is delivered to the source queue before being moved to the dead letter queue. | `number` | `10` | no |
| <a name="input_sqs_message_retention_seconds"></a> [sqs\_message\_retention\_seconds](#input\_sqs\_message\_retention\_seconds) | The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days). | `number` | `1209600` | no |
| <a name="input_sqs_queue_arn"></a> [sqs\_queue\_arn](#input\_sqs\_queue\_arn) | ARN of an existing SQS event source queue. | `string` | `null` | no |
| <a name="input_sqs_queue_name"></a> [sqs\_queue\_name](#input\_sqs\_queue\_name) | Name of the event source queue if you want this module to create a combination queue and dead letter queue. | `string` | `null` | no |
| <a name="input_sqs_receive_wait_time_seconds"></a> [sqs\_receive\_wait\_time\_seconds](#input\_sqs\_receive\_wait\_time\_seconds) | The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds). | `number` | `20` | no |
| <a name="input_sqs_visibility_timeout_seconds"></a> [sqs\_visibility\_timeout\_seconds](#input\_sqs\_visibility\_timeout\_seconds) | The visibility timeout for the queue. An integer from 0 to 43200 (12 hours). | `number` | `300` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Lambda timeout in seconds. | `string` | n/a | yes |
| <a name="input_tracing_mode"></a> [tracing\_mode](#input\_tracing\_mode) | Whether to to sample and trace a subset of incoming requests with AWS X-Ray. Valid values are PassThrough and Active. If PassThrough, Lambda will only trace the request from an upstream service if it contains a tracing header with 'sampled=1'. If Active, Lambda will respect any tracing header it receives from an upstream service. If no tracing header is received, Lambda will call X-Ray for a tracing decision. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dl_queue_arn"></a> [dl\_queue\_arn](#output\_dl\_queue\_arn) | Dead letter queue arn. |
| <a name="output_dl_queue_url"></a> [dl\_queue\_url](#output\_dl\_queue\_url) | Dead letter queue url. |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | Queue arn. |
| <a name="output_queue_url"></a> [queue\_url](#output\_queue\_url) | Queue url. |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | Lambda function ARN. |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | Lambda function name. |


## About harrison.ai

This module is maintained by the Platform team at [harrison.ai](https://harrison.ai).

At [harrison.ai](https://harrison.ai) our mission is to create AI-as-a-medical-device solutions through ventures and ultimately improve the standard of healthcare for 1 million lives every day.

## License

Licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).

Copyright 2022 harrison.ai Pty. Ltd.
