data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_sqs_default" {
  count = local.sqs_use_module ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      aws_sqs_queue.queue[0].arn,
      aws_sqs_queue.dlqueue[0].arn
    ]
  }
}

data "aws_iam_policy_document" "lambda_combined" {
  source_policy_documents = local.sqs_use_module ? [
    data.aws_iam_policy_document.lambda_sqs_default[0].json,
    var.lambda_policy
    ] : [
    var.lambda_policy
  ]
}

data "aws_iam_policy_document" "queue" {
  count = local.sqs_use_module ? 1 : 0

  statement {
    sid    = "DefaultPolicy"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "SQS:*"
    ]
    resources = [
      aws_sqs_queue.queue[0].arn
    ]
  }
}

data "aws_iam_policy_document" "dlqueue" {
  count = local.sqs_use_module ? 1 : 0

  statement {
    sid    = "DefaultPolicy"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "SQS:*"
    ]
    resources = [
      aws_sqs_queue.dlqueue[0].arn
    ]
  }
}
