# rivada-code-challenge
Image Processor Setup

![ImageProcessorEC2 drawio](https://github.com/kunalsnehi0710/rivada-code-challenge/assets/167197970/d65b65ed-bb48-4ccf-8343-afd44ebbde68)

AWS Resources needed:
 - S3 bucket
 - Lambda Function
 - Cloudwatch Event Trigger to invoke Lambda function
 - AWS Batch EC2 Compute Environment (to process 32 GB images, we cannot use Fargate due to max limit of 30GB RAM with Fargate)
 - AWS Batch Job Definition
 - AWS Batch Job-queue
 - AWS Batch Job
 - AWS ECR Registry
 - IAM Roles/Policies

Terraform code under terraform/ :

- aws_batch.tf
- ecr.tf
- s3_lambda.tf


Gitlab CI Yaml:

- gitlab-ci.yml
