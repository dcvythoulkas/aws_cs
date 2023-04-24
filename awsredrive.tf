resource "aws_instance" "awsredrive_server" {
  ami                    = "ami-08f13e5792295e1b2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.main.id]

  key_name = "osuser"

  user_data                   = <<-EOF
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
