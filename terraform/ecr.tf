
resource "aws_ecr_repository" "img-processor" {
  name = "img-processor-repo"
}

resource "aws_iam_role" "img-processor_job_role" {
  # ... role configuration
}

resource "aws_iam_role" "img-processor_execution_role" {
  # ... role configuration
}