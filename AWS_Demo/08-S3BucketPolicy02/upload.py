import boto3

session = boto3.Session(profile_name="Dave")   # Define the profile session
s3_client = session.client('s3')     # use the profile session
object_name = "testUpload.File"  # change the name on the S3 Bucket

bucket_name = "eraki-s3-dev-01"
file_path = "/home/ec2-user/upload.file"

try:
    object = s3_client.upload_file(file_path, bucket_name, object_name)

    print(f"File '{file_path}' uploaded successfully to S3 bucket '{bucket_name}' / '{object_name}' !")
except Exception as e:
    print(f"Error uploading file: {e}")    
       
