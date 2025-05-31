output "s3_bucket_name" {
  value       = aws_s3_bucket.flight_data_bucket.id
  description = "The name of the S3 bucket for the flight data lake"
}

output "glue_job_name" {
  value       = aws_glue_job.transform_flight_data.name
  description = "The name of the AWS Glue ETL job"
}

output "glue_role_arn" {
  value       = aws_iam_role.glue_service_role.arn
  description = "The ARN of the IAM role assigned to the Glue job"
}
