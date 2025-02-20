# S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "imseanconroy-disturbance-free-calling"

  tags = {
    project = "disturbance-free-calling"
  }
}

# S3 Bucket Object
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "deployment"
  source = "./deployment.zip"
}