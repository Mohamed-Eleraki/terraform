import json
import boto3

s3  = boto3.resource('s3')

def lambda_handler(event, context):
    bucket_list = []
    for bucket in s3.buckets.all():
        print(bucket.name)
        bucket_list.append(bucket.name)
    return {
        'statusCode': 200,
        'body': bucket_list
    }
    
# https://www.youtube.com/watch?v=-8L4OxotXlE