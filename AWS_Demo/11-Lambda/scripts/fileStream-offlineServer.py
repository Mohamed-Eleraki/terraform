import boto3

def lambda_handler(event, context):

    # Retrieve the SSM document name from environment variable (optional)
    # ssm_document_name = os.environ['SSM_DOCUMENT_NAME']

    # Hardcode the document name for simplicity
    ssm_document_name = "Documentname"
    offline_instance_id = "instanceID"

    # Create an SSM client
    ssm_client = boto3.client('ssm')

    try:
        # Send the SSM document execution command
        response = ssm_client.send_command(
            InstanceIds=[offline_instance_id],
            DocumentName=ssm_document_name
        )

        # Retrieve the command ID for tracking (optional)
        command_id = response['Command']['CommandId']

        # Print a success message
        print(f"SSM document '{ssm_document_name}' execution initiated.")

    except Exception as e:
        print(f"Error occurred: {e}")
        raise

    return {
        'statusCode': 200,
        'body': f"SSM document '{ssm_document_name}' execution started."
    }
