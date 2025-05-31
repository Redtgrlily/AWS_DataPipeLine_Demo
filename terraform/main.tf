provider "aws" {
  region = var.aws_region
}

# -----------------------------
# S3 Buckets for Data Lake
# -----------------------------
resource "aws_s3_bucket" "flight_data_bucket" {
  bucket = var.s3_bucket_name
  force_destroy = true

  tags = {
    Name        = "Flight Data Lake"
    Environment = "dev"
    Project     = "FlightETL"
  }
}

# -----------------------------
# IAM Role for Glue
# -----------------------------
resource "aws_iam_role" "glue_service_role" {
  name = "AWSGlueServiceRoleDefault"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "glue.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "glue_attach_policy" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# -----------------------------
# Glue Job (ETL)
# -----------------------------
resource "aws_glue_job" "transform_flight_data" {
  name     = "transform-flight-data"
  role_arn = aws_iam_role.glue_service_role.arn

  command {
    name            = "glueetl"
    script_location = "s3://${var.s3_bucket_name}/scripts/transform_flight_data.py"
    python_version  = "3"
  }

  glue_version      = "3.0"
  max_retries       = 0
  number_of_workers = 2
  worker_type       = "G.1X"

  default_arguments = {
    "--TempDir"                          = "s3://${var.s3_bucket_name}/temp/"
    "--job-language"                    = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-metrics"                  = "true"
    "--job-bookmark-option"             = "job-bookmark-disable"
  }
}
