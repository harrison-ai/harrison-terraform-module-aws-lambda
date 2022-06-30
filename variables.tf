##  -----  Lambda Variables  -----  ##

variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "image_uri" {
  type = string
}

variable "entry_point" {
  type    = list(string)
  default = null
}

variable "command" {
  type    = list(string)
  default = null
}

variable "memory_size" {
  type = string
}

variable "timeout" {
  type = string
}

variable "batch_size" {
  type    = number
  default = 10
}

variable "maximum_batching_window_in_seconds" {
  type    = number
  default = 30
}

variable "cloudwatch_retention_in_days" {
  type    = number
  default = 30
}

variable "envvars" {
  type    = map(string)
  default = {}
}

variable "lambda_policy" {
  type    = string
  default = null
}

variable "architectures" {
  type = list(string)
}

variable "ephemeral_storage_size" {
  description = "Amount of ephemeral storage (/tmp) in MB your Lambda Function can use at runtime. Valid value between 512 MB to 10,240 MB (10 GB)."
  type        = number
  default     = 412
}

variable "tracing_mode" {
  type    = string
  default = null
}

variable "iam_abac_tags" {
  type    = map(string)
  default = {}
}

variable "event_source_arn" {
  type = string
}
