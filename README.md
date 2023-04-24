# A SNS-SQS-AWSRedrive connection

## Synopsis
In short we use Terraform (and ONLY Terraform) to create a pair of Amazon SNS topic, subscribe a newly created Amazon SQS queue to it and then launch an Amazon EC2 instance with AWSRedrive installed, configured to attach to the nrew queue and running in tha background.

## Prerequisites
1. Install Terraform
2. Install AWS cli
3. Let's not put the root account do all the work and get some RBAC
  1. Create a dummy group in AWS IAM
  2. Grant the following permissions on the dummy group:
    *. AmazonEC2FullAccess
    *. AmazonSQSFullAccess
    *. AmazonVPCFullAccess
    *. AmazonSNSFullAccess
  3. Create a dummy user in AWS IAM and assign him to our dummy group
  4. Create a AWS Access key pair
4. Add the Access key pair to our .bashrc
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
