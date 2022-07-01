terraform {

  required_version = ">= 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = local.region
  profile = local.profile

  default_tags {
    tags = {
      Project = local.project
      Repo    = local.repo
    }
  }
}
