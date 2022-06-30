data "aws_iam_policy_document" "lambda_policy" {
  statement {
    sid    = "1"
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "2"
    effect    = "Allow"
    actions   = [ "s3:GetBucketLocation" ]
    resources = [ "*" ]
  }
}

