import boto3

session = boto3.Session(profile_name="Dave")   # Define the profile session
s3_client = session.client('s3')
object_name = "testUpload.File"  # The name of the file in the S3 bucket you want to download

bucket_name = "eraki-s3-dev-01"
download_path = "/home/ec2-user/testUpload.File"  # Local path to save the downloaded file

try:
    s3_client.download_file(bucket_name, object_name, download_path)

    print(f"File '{object_name}' downloaded successfully from S3 bucket '{bucket_name}' to '{download_path}' !")
except Exception as e:
    print(f"Error downloading file: {e}")
