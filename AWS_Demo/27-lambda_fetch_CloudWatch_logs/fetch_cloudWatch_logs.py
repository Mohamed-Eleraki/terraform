import boto3
import os
from datetime import datetime, timedelta

# Initialize the AWS clients
logs_client = boto3.client('logs')
s3_client = boto3.client('s3')

# Environment variables for S3 bucket and log group
S3_BUCKET = os.environ['S3_BUCKET'].strip()  # fetch environment variable
LOG_GROUP_NAME = os.environ['LOG_GROUP_NAME'].strip()  # fetch environment variable

def lambda_handler(event, context):
    try:
        # Get the current time and time 5 minutes ago (adjust as needed)
        end_time = datetime.utcnow()
        start_time = end_time - timedelta(minutes=5000)
        
        # Convert to timestamps in milliseconds
        start_time_ms = int(start_time.timestamp() * 1000)
        end_time_ms = int(end_time.timestamp() * 1000)
        
        # Fetch log streams for the specified log group
        log_streams = logs_client.describe_log_streams(
            logGroupName=LOG_GROUP_NAME,
            orderBy='LastEventTime',
            descending=True
        )['logStreams']
        
        for stream in log_streams:
            log_stream_name = stream['logStreamName']
            print(f'Processing log stream: {log_stream_name}')
            
            # Fetch log events from the log stream
            log_events = logs_client.get_log_events(
                logGroupName=LOG_GROUP_NAME,
                logStreamName=log_stream_name,
                startTime=start_time_ms,
                endTime=end_time_ms,
                startFromHead=True
            )['events']
            
            # Combine log messages
            log_data = '\n'.join(event['message'] for event in log_events)
            print(f'Fetched {len(log_events)} events')
            
            if log_data:
                # Create a filename for the S3 object
                filename = f'{LOG_GROUP_NAME}/{log_stream_name}/{start_time.strftime("%Y-%m-%dT%H-%M-%S")}.log'
                print(f'Uploading log data to S3 bucket: {S3_BUCKET}, key: {filename}')
                
                # Upload the log data to S3
                s3_client.put_object(
                    Bucket=S3_BUCKET,
                    Key=filename,
                    Body=log_data
                )
        
        print('Logs forwarded to S3 successfully')
        return {
            'statusCode': 200,
            'body': 'Logs forwarded to S3 successfully'
        }
        
    except Exception as e:
        print(f'Error forwarding logs: {str(e)}')
        return {
            'statusCode': 500,
            'body': f'Error forwarding logs: {str(e)}'
        }
