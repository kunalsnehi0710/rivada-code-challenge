# AWS Batch compute environment
resource "aws_batch_compute_environment" "img-processor" {
  compute_environment_name = "img-processor-compute-env"
  type                     = "MANAGED"
  service_role             = aws_iam_role.batch_service_role.arn

  compute_resources {
    type                = "EC2"
    instance_role       = aws_iam_instance_profile.batch_instance_profile.arn
    min_vcpus           = 0
    max_vcpus           = 16
    desired_vcpus       = 16
    instance_types      = ["m5.4xlarge"] # 16vCPU, 32 GBRAM
    subnets             = ["subnet-1234abcd", "subnet-5678efgh"]
    security_group_ids  = ["sg-0123456789abcdef"]
  }
}


# Create AWS Batch job queue
resource "aws_batch_job_queue" "img-processor" {
  name                 = "img-processor-job-queue"
  state                = "ENABLED"
  priority             = 1
  compute_environment_order {
    compute_environment = aws_batch_compute_environment.img-processor.arn
    order               = 1
  }
}

# Create AWS Batch job definition
resource "aws_batch_job_definition" "img-processor" {
  name = "img-processor-job-definition"
  type = "container"

  container_properties = jsonencode({
    image = "${aws_ecr_repository.img-processor.repository_url}:latest" # Replace with your desired Docker image
    command = ["python", "/app/script.py"] # Replace with your Python script path
    volumes = [
      {
        host_path = "/src"
        name      = "src"
      }
    ]
    mountPoints = [
      {
        containerPath = "/src"
        sourceVolume  = "src"
      }
    ]
  })
}

# Submit AWS Batch job
resource "aws_batch_job" "img-processor" {
  name                = "img-processor-job"
  job_definition      = aws_batch_job_definition.img-processor.arn
  job_queue           = aws_batch_job_queue.img-processor.arn
  container_overrides = jsonencode({
    command = ["python", "/app/script.py", "arg1", "arg2"] # Replace with your script arguments
  })
}

# CloudWatch Event Rule
resource "aws_cloudwatch_event_rule" "img-processor" {
  name        = "img-processor-event-rule"
  description = "Trigger Lambda function on S3 object creation or update"

  event_pattern = jsonencode({
    source = ["aws.s3"]
    detail-type = ["Object Created", "Object Updated"]
    detail = {
      bucket = {
        name = [aws_s3_bucket.img-processor.id]
      }
    }
  })
}

# CloudWatch Event Target
resource "aws_cloudwatch_event_target" "img-processor" {
  rule      = aws_cloudwatch_event_rule.img-processor.name
  arn       = aws_lambda_function.img-processor.arn
}