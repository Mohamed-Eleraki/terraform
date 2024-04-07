import boto3
import os

def lambda_handler(event, context):

    # Retrieve the SSM document name from environment variable (optional)
    # ssm_document_name = os.environ['SSM_DOCUMENT_NAME']

    # Hardcode the document name for simplicity
    ssm_document_name = "ssm_document_shell_configs"
    ec2_instance_id = os.environ['EC2_INSTANCE_ID']  # hold the instance ID from environment variable

    # Create an SSM client
    ssm_client = boto3.client('ssm', region_name='us-east-1')
    
    # Define command parameters
    document_name = ssm_document_name
    document_version = "1"
    targets = [{"Key": "InstanceIds", "Values": [ec2_instance_id]}]
    parameters = {}  # No parameters specified in the command
    timeout_seconds = 120
    max_concurrency = "5"
    max_errors = "1"
    

    try:
        # Send the SSM document execution command
        response = ssm_client.send_command(
            DocumentName=document_name,
            DocumentVersion=document_version,
            Targets=targets,
            Parameters=parameters,
            TimeoutSeconds=timeout_seconds,
            MaxConcurrency=max_concurrency,
            MaxErrors=max_errors
        )

        # Print a success message
        print(f"Command sent successfully. Command ID: {response['Command']['CommandId']}")

    except Exception as error:
        print(f"Error occurred: {error}")
