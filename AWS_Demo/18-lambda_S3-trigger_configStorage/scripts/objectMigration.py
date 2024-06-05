import boto3
import os

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    destination_bucket = os.environ['DEST_BUCKET']
    
    for record in event['Records']:
        source_bucket = record['s3']['bucket']['name']
        source_key = record['s3']['object']['key']
        
        copy_source = {'Bucket': source_bucket, 'Key': source_key}
        
        try:
            s3.copy_object(
                Bucket=destination_bucket,
                CopySource=copy_source,
                Key=source_key
            )
            print(f"File copied from {source_bucket}/{source_key} to {destination_bucket}/{source_key}")
        except Exception as e:
            print(f"Error copying file: {e}")
            raise e
