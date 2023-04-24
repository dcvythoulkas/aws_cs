# A SNS-SQS-AWSRedrive connection

## Synopsis
In short we use Terraform (and ONLY Terraform) to create an Amazon SNS topic, subscribe a newly created Amazon SQS queue to it and then launch an Amazon EC2 instance with AWSRedrive installed, configured to attach to the new queue and running in the background.

## Prerequisites
1. Install Terraform
2. Install AWS cli
3. Let's not put the root account do all the work and get some RBAC

    1. Create a dummy group in AWS IAM
    2. Grant the following permissions on the dummy group:
  
        * AmazonEC2FullAccess
        * AmazonSQSFullAccess
        * AmazonVPCFullAccess
        * AmazonSNSFullAccess
  
    3. Create a dummy user in AWS IAM and assign him to our dummy group
    4. Create a AWS Access key pair for our dummy user

4. Add the Access key pair to our .bashrc
5. (Optionally) Add your publlic SSH RSA key to variables.tf, so you can verify everything is working
```
export AWS_ACCESS_KEY_ID=<DUMMY_USER_ACCESS_KEY>
export TF_VAR_aws_access_key=<DUMMY_USER_ACCESS_KEY>
export AWS_SECRET_ACCESS_KEY=<DUMMY_USER_SECRET_ACCESS_KEY>
export TF_VAR_aws_secret_access_key=<DUMMY_USER_SECRET_ACCESS_KEY>
```

## Run
Deploy with Terraform as usual

```
terraform init
terraform apply
```

## Verify operation
AWSRedrive is installed, configured and set in a running state via `user_data`. This is set up upon EC2 instance creation and any change in the AWSRedrive configuration will force the instance to be recreated. Because of this (instance never survives configuration changes), the AWSRedrive process runs within a `screen` session of the root account. We can use  `screen -ls` and `screen -r` to attach to the running process and monitor its execution.
