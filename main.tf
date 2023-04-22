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

resource "aws_sqs_queue" "dummy_queue" {
  name       = "dummy_queue.fifo"
  fifo_queue = true
}

resource "aws_sns_topic_subscription" "dummy_topic_sqs_target" {
  topic_arn = aws_sns_topic.dummy_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.dummy_queue.arn
}

data "aws_iam_policy_document" "dummy_queue_policy" {
  statement {
    sid    = "__owner_statement"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::445198443645:root"]
    }

    actions   = ["sqs:*"]
    resources = [aws_sqs_queue.dummy_queue.arn]
  }
  statement {
    sid    = "topic-subscription-arn:aws:sns:eu-central-1:445198443645:dummy_topic.fifo"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.dummy_queue.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.dummy_topic.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "dummy_queue_policy" {
  queue_url = aws_sqs_queue.dummy_queue.id
  policy    = data.aws_iam_policy_document.dummy_queue_policy.json
}
