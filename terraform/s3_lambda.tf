# S3 bucket
resource "aws_s3_bucket" "img-processor" {
  bucket = "img-processor-bucket"
}

# Lambda function
resource "aws_lambda_function" "img-processor" {
  # ... Lambda function configuration ...
}

resource "aws_lambda_permission" "img-processor" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.img-processor.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.img-processor.arn
}
