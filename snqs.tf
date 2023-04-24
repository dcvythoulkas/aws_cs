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
    sid    = "topic-subscription"
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
