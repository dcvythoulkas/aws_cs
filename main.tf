provider "aws" {
  region = var.aws_region
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

resource "aws_key_pair" "osuser" {
  key_name   = "osuser"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhneFC8a9R87Uq1JAqD4T2CENZ6VThuxcKbz0JxNmCZvsB0+GGVqLqUAEXXprUes7ab2QCbHq/PooIgo1uE12GEwfele78291xnTuR/dAIetNsoRSYAxnrVMlnBLc3f5XfVbeZ01YpVUxxShDNiRskZlxWwELrO9qgITTiwdg7izby5POdPkMNvEpdA8acuBT03vhKTPmO2o0uqc5+mbIinCXYe9copvRn5SmfeQzyWsLz8OAh5KJ+czNIHo8UXievaxo3oph/28/MOS8NMB9Jls4m9wSQs21p6DbIze2pq36U5yVW/pldu0+IBpG34sCy46guA3IocciCDvvXo8W9"
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
}

resource "aws_instance" "awsredrive_server" {
  ami           = "ami-08f13e5792295e1b2"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.main.id]

  key_name = "osuser"

  user_data = <<-EOF
        #!/bin/bash
        sudo apt-get update
        sudo apt-get -y install unzip wget tree screen htop
        sudo wget https://github.com/nickntg/awsredrive.core/releases/download/1.0.9/awsredrive.core.linux-console.zip -O /opt/awsredrive.core.linux-console.zip
        sudo unzip /opt/awsredrive.core.linux-console.zip -d /opt/awsredrive.core.linux-console
        echo '[{"Alias": "#1","AccessKey": "${var.aws_access_key}","SecretKey": "${var.aws_secret_access_key}","QueueUrl": "${aws_sqs_queue.dummy_queue.url}","RedriveUrl": "${var.redrive_url}","Region": "${var.aws_region}","Active": true,"Timeout": 10000,"UseGET": true}]' > /opt/awsredrive.core.linux-console/config.json
        chmod u+x /opt/awsredrive.core.linux-console/AWSRedrive.console
        cd /opt/awsredrive.core.linux-console/; screen -d -m ./AWSRedrive.console
	EOF
  user_data_replace_on_change = true

  tags = {
    Name = "ExampleAWSRedriveInstance"
  }
}
