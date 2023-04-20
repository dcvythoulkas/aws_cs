terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.63.0"
    }
  }

  required_version = "1.4.5"
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_sns_topic" "dummy_topic" {
  name       = "dummy_topic.fifo"
  fifo_topic = true
}

# data "aws_sns_topic" "dummy_topic" {
#   name = "dummy_topic.fifo"
# }

resource "aws_sqs_queue" "dummy_queue" {
  name                        = "dummy_queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

# data "aws_sqs_queue" "dummy_queue" {
#   name = "dummy_queue.fifo"
# }

resource "aws_sns_topic_subscription" "dummy_topic_sqs_target" {
  topic_arn = aws_sns_topic.dummy_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.dummy_queue.arn
}
