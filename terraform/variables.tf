variable "aws_region" {
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for flight data"
  default     = "flight-data"
}
