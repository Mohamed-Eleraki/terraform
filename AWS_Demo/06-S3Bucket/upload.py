import boto3

s3_client = boto3.client('s3')
object_name = "testUpload.File"

bucket_name = "eraki-s3-dev-01"
file_path = "/root/testUpload.File"

try:
    object = s3_client.upload_file(file_path, bucket_name, object_name)

    print(f"File '{file_path}' uploaded successfully to S3 bucket '{bucket_name}' / '{object_name}' !")
except Exception as e:
    print(f"Error uploading file: {e}")    
       