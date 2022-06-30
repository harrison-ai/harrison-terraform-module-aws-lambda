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

## Who do I talk to?

- Repo owner or admin Carl Hattingh(carl.hattingh@harrison.ai)
- Harrison.ai Data Engineering team

## Contributing

## Credits

This repository was created using the [harrison-ai terraform cookiecutter] template (https://github.com/harrison-ai/cookiecutter-terraform)
