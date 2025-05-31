import json
import boto3
import urllib3
from datetime import datetime
import os
import uuid

# For local testing — simulate boto3 and S3
USE_LOCAL_FILE = True

# Constants
API_URL = "https://opensky-network.org/api/states/all"
S3_BUCKET = "flight-data"
RAW_FOLDER = "raw"

# Set up HTTP client
http = urllib3.PoolManager()

def lambda_handler(event, context):
    # Get current timestamp
    now = datetime.utcnow()
    timestamp = now.strftime('%Y-%m-%dT%H:%M:%SZ')
    date_path = now.strftime('year=%Y/month=%m/day=%d/hour=%H')

    # Make API request
    try:
        response = http.request("GET", API_URL)
        if response.status != 200:
            raise Exception(f"API request failed with status {response.status}")
        data = json.loads(response.data.decode('utf-8'))

        # Construct file name
        filename = f"flights_{timestamp}_{uuid.uuid4().hex[:6]}.json"
        s3_key = f"{RAW_FOLDER}/{date_path}/{filename}"

        if USE_LOCAL_FILE:
            # Save locally for simulation
            os.makedirs(f"sample_output/{RAW_FOLDER}/{date_path}", exist_ok=True)
            with open(f"sample_output/{s3_key}", "w") as f:
                json.dump(data.get("states", []), f, indent=2)
            print(f"✅ Saved simulated data to sample_output/{s3_key}")
        else:
            # Upload to S3 (production Lambda)
            s3 = boto3.client("s3")
            s3.put_object(
                Bucket=S3_BUCKET,
                Key=s3_key,
                Body=json.dumps(data.get("states", [])),
                ContentType="application/json"
            )
            print(f"✅ Uploaded data to s3://{S3_BUCKET}/{s3_key}")

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Flight data ingested", "key": s3_key})
        }

    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }