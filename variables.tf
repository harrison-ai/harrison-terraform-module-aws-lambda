##  -----  Lambda Variables  -----  ##

variable "name" {
  description = "Name of the Lambda."
  type        = string
}

variable "description" {
  description = "Description of the Lambda."
  type        = string
}

variable "image_uri" {
  description = "Private ECR repository URI."
  type        = string
}

variable "entry_point" {
  description = "Entrypoint of Lambda. This is equivalent to Docker ENTRYPOINT."
  type        = list(string)
  default     = null
}

variable "command" {
  description = "Command to run in Lambda. This is equivalent to Docker CMD."
  type        = list(string)
  default     = null
}

variable "memory_size" {
  description = "Memory size of the lambda in megabytes."
  type        = string
}

variable "timeout" {
  description = "Lambda timeout in seconds."
  type        = string
}

variable "batch_size" {
  description = "The largest number of records that Lambda will retrieve from the queue at the time of invocation. Defaults to 10 for SQS."
  type        = number
  default     = 10
}

variable "maximum_batching_window_in_seconds" {
  description = "The maximum amount of time to gather records before invoking the function, in seconds (between 0 and 300). Records will continue to accumulate until either maximum_batching_window_in_seconds expires or batch_size has been met."
  type        = number
  default     = 30
}

variable "function_response_types" {
  description = "Set to ReportBatchItemFailures to allow Lambda to return paritial success/failures."
  type        = string
  default     = null
}

variable "cloudwatch_retention_in_days" {
  description = "Days to keep Cloudwatch logs before they are deleted."
  type        = number
  default     = 30
}

variable "envvars" {
  description = "Map of environment variables for the Lambda function."
  type        = map(string)
  default     = {}
}

variable "lambda_policy" {
  description = "Additional aws_iam_policy resource to include."
  type        = string
  default     = null
}

variable "architectures" {
  description = "Architectures to use. For example x86_64."
  type        = list(string)
}

variable "ephemeral_storage_size" {
  description = "Amount of ephemeral storage (/tmp) in MB your Lambda Function can use at runtime. Valid value between 512 MB to 10,240 MB (10 GB)."
  type        = number
  default     = 512
}

variable "tracing_mode" {
  description = "Whether to to sample and trace a subset of incoming requests with AWS X-Ray. Valid values are PassThrough and Active. If PassThrough, Lambda will only trace the request from an upstream service if it contains a tracing header with 'sampled=1'. If Active, Lambda will respect any tracing header it receives from an upstream service. If no tracing header is received, Lambda will call X-Ray for a tracing decision."
  type        = string
  default     = null
}

variable "iam_abac_tags" {
  description = "ABAC tags to pass. See https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction_attribute-based-access-control.html"
  type        = map(string)
  default     = {}
}

##  -----  SQS Variables  -----  ##

variable "sqs_queue_arn" {
  description = "ARN of an existing SQS event source queue."
  type        = string
  default     = null
}

variable "sqs_queue_name" {
  description = "Name of the event source queue if you want this module to create a combination queue and dead letter queue."
  type        = string
  default     = null
}

variable "sqs_max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB). The default for this attribute is 262144 (256 KiB)"
  type        = number
  default     = 262144
}

variable "sqs_message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)."
  type        = number
  default     = 1209600
}

variable "sqs_receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)."
  type        = number
  default     = 20
}

variable "sqs_visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)."
  type        = number
  default     = 300
}

variable "sqs_encryption_enabled" {
  description = "Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys."
  type        = bool
  default     = false
}

variable "sqs_max_receive_count" {
  description = "The number of times a message is delivered to the source queue before being moved to the dead letter queue."
  type        = number
  default     = 10
}
