variable "name" {
  type = string
}

variable "max_message_size" {
  type    = number
  default = 262144
}

variable "message_retention_seconds" {
  type    = number
  default = 1209600
}

variable "receive_wait_time_seconds" {
  type    = number
  default = 20
}

variable "visibility_timeout_seconds" {
  type    = number
  default = 300
}

variable "encryption" {
  type    = string
  default = null
}

variable "max_receive_count" {
  type    = number
  default = 10
}
