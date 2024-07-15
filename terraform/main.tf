terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.26.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-2"
  assume_role {
    role_arn     = "arn:aws:iam::891377173175:role/admin-access-role"
    session_name = "admin-terraform-session"
  }
}

module "sns" {
  source = "./modules/sns"
}

module "sqs" {
  source = "./modules/sqs"
}

module "lambda" {
  source         = "./modules/lambda"
  sns_topic_arn  = module.sns.sns_topic_arn
  sqs_queue_url  = module.sqs.sqs_queue_url
}