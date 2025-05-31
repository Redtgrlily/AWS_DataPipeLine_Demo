# Flight Data ETL Pipeline on AWS - Portfolio Demo

---

## 🚀 Project Overview

This repository showcases an end-to-end **flight data ETL pipeline** designed using AWS managed services, illustrating core data engineering skills such as ingestion, transformation, storage, and analytics. 

The pipeline processes real-time flight data from the [OpenSky Network API](https://opensky-network.org/apidoc/rest.html), stores raw data in an S3 data lake, cleans and transforms it using AWS Glue, loads it into Redshift for querying, and provides sample analytical queries for dashboarding.

---

## 🎯 Project Goals

- Build a robust **data lake** architecture with **S3** for scalable storage.
- Implement **ETL jobs** using **AWS Glue** to clean and process raw flight data.
- Load transformed data into **Amazon Redshift** for performant analytical querying.
- Automate data ingestion with AWS Lambda and orchestration with CloudWatch or Step Functions.
- Demonstrate **Infrastructure-as-Code (IaC)** using Terraform to define AWS resources.
- Create meaningful analytical queries showcasing real-world aviation insights.

---

## 🗂 Repository Structure

```plaintext
.
├── lambda/
│   └── ingest_flight_data.py           # Lambda function to ingest flight data from OpenSky API
├── glue_jobs/
│   └── transform_flight_data.py        # AWS Glue ETL PySpark script for cleaning and transforming data
├── sample_data/
│   └── flights_sample.json              # Sample input JSON data mimicking OpenSky API schema
├── config/
│   └── glue_job_config.json             # Glue job configuration JSON file
├── dashboard/
│   └── redshift_queries.sql             # Example analytical queries to run on Redshift
├── sql/
│   └── redshift_table_schema.sql       # SQL schema to create Redshift tables
├── terraform/
│   ├── main.tf                         # Terraform resources defining S3 bucket, Glue job, IAM roles
│   ├── variables.tf                    # Terraform input variables
│   └── outputs.tf                      # Terraform output values
├── sample_output/                      # Local simulated outputs (ignored by Git)
├── .gitignore                         # Git ignore rules
└── README.md                         # This file

## Technology Stack
Layer	Service/Tool
Data Ingestion	AWS Lambda, OpenSky API
Data Lake Storage	AWS S3
ETL Processing	AWS Glue (PySpark)
Data Warehouse	Amazon Redshift
Orchestration	AWS CloudWatch / Step Functions (not implemented in code)
Infrastructure as Code	Terraform

## Key Components Explained
1. Data Ingestion - lambda/ingest_flight_data.py
Fetches live flight state data from OpenSky API.

Stores raw JSON files in S3 with partitioned paths (year=.../month=.../day=.../hour=...).

Includes a local simulation mode to write sample data files locally without AWS costs.

2. Data Lake Storage - Amazon S3
Raw data is stored in a dedicated S3 bucket (flight-data).

Partitioned folders improve query efficiency and organization.

3. ETL Processing - AWS Glue
Glue job transform_flight_data.py reads raw JSON, cleans and enriches the dataset.

Adds partition columns (year, month, day) for easy filtering.

Writes processed data back to S3 in Parquet format for efficient querying.

Glue job configuration is in config/glue_job_config.json.

4. Data Warehouse - Amazon Redshift
Table schema defined in sql/redshift_table_schema.sql.

Sample analytical queries available in dashboard/redshift_queries.sql.

Queries cover flight counts, velocity analysis, geographic heatmaps, and time-series aggregation.

5. Infrastructure as Code - Terraform
Terraform files (terraform/*.tf) define:

S3 bucket for storage

IAM roles for Glue

Glue ETL job with configuration and script path

Variables and outputs provide flexibility and clarity.

## Sample Data
sample_data/flights_sample.json mimics OpenSky API flight state responses, allowing local development and testing of Glue ETL scripts without AWS dependencies.

## How to Use Locally / Test
Test Glue ETL Locally:

Use PySpark locally to run transform_flight_data.py on sample_data/flights_sample.json.

Change file paths in the script accordingly.

Simulate Lambda Data Ingestion:

Run lambda/ingest_flight_data.py with local mode enabled.

Check sample_output/raw/ folder for JSON dumps.

Terraform Plan:

Run terraform init and terraform plan inside terraform/ folder to see resource creation plan (no apply needed).

Query Redshift:

Use the SQL files to create schema and run queries in your Redshift cluster if available.

## Additional Notes
The project demonstrates best practices in cloud-native data engineering.

Partitioned storage layout and Glue bookmarks help incremental processing.

Use of IAM roles and least privilege concepts are modeled in Terraform.

Query examples show how to derive meaningful analytics from aviation data.