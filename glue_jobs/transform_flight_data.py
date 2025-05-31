import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql.functions import col, to_timestamp
from awsglue.context import GlueContext
from awsglue.job import Job

args = getResolvedOptions(sys.argv, ['JOB_NAME'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

raw_df = spark.read.json("s3://flight-data/raw/")

cleaned_df = raw_df \
    .filter(col("icao24").isNotNull()) \
        .withColumn("timestmap", to_timestamp(col("time_position"))) \
            .dropDuplicates()

cleaned_df.write \
    .mode("overwrite") \
        .partitionBy("year", "month", "day") \
            .parquet("s3://flight-data/processed/")
            
job.commit()