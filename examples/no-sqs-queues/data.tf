data "aws_iam_policy_document" "lambda_policy" {
  statement {
    sid       = "example"
    effect    = "Allow"
    actions   = "s3:GetBucketLocation"
    resources = "*"
  }
}
