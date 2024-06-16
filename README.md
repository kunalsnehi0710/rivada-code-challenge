# rivada-code-challenge
Image Processor Setup

![ImageProcessor_latest drawio](https://github.com/kunalsnehi0710/rivada-code-challenge/assets/167197970/e0b92b1c-0c7c-475a-8526-7812261903b6)


**AWS Resources deployed**:
 - S3 bucket
 - Lambda Function
 - Cloudwatch Event Trigger to invoke Lambda function
 - AWS Batch EC2 Compute Environment (to process 32 GB images, we cannot use Fargate due to max limit of 30GB RAM with Fargate)
 - AWS Batch Job Definition
 - AWS Batch Job-queue
 - AWS Batch Job
 - AWS ECR Registry
 - IAM Roles/Policies


**How it works?**

User or program uploads raw images to S3 bucket, from where a cloudwatch event triggers to invoke Lambda function. Lambda function is designed to schedule AWS Batch Jobs on EC2 compute environment which pulls docker image from ECR registry and executes Python app to process these large images and eventually publishes the transformed images to the destination path on S3 bucket using AWS SDK on EC2.

**Note**: EC2 is used instead of serverless Fargate solution due to max limit of 30 GB RAM with Fargate, we need atleast 40 GB RAM to process the large images.

**Further scope of improvement**: We can also include the use of Spot instances instead of regular EC2 if the image transformation operation is not mission-critical.


**Terraform code under terraform/** :

- aws_batch.tf
- ecr.tf
- s3_lambda.tf


**Gitlab CI script**:

- gitlab-ci.yml
