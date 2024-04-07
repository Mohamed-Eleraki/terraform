import boto3

def lambda_handler(event, context):
    # Create SSM client in the specified region
    ssm_client = boto3.client('ssm', region_name='us-east-1')
    
    # Define command parameters
    document_name = "ssm_document_shell_configs"
    document_version = "1"
    targets = [{"Key": "InstanceIds", "Values": ["i-07523fd081e6dbe0d"]}]
    parameters = {}  # No parameters specified in the command
    timeout_seconds = 120
    max_concurrency = "5"
    max_errors = "0"
    
    # Send the command
    try:
        response = ssm_client.send_command(
            DocumentName=document_name,
            DocumentVersion=document_version,
            Targets=targets,
            Parameters=parameters,
            TimeoutSeconds=timeout_seconds,
            MaxConcurrency=max_concurrency,
            MaxErrors=max_errors
        )
        print(f"Command sent successfully. Command ID: {response['Command']['CommandId']}")
    except Exception as error:
        print(f"Error sending command: {error}")

