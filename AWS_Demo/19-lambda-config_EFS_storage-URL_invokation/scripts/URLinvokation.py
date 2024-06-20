import json
import os

def lambda_handler(event, context):
    # Print the raw event content for debugging
    print("Received event:", json.dumps(event))
    
    # Parse the body if it exists and is a string
    if 'body' in event:
        try:
            event_body = json.loads(event['body'])
        except json.JSONDecodeError:
            return {
                'statusCode': 400,
                'body': json.dumps("Error: Could not decode JSON payload.")
            }
    else:
        event_body = event
    
    directory_name = event_body.get("directory_name")
    
    if not directory_name:
        return {
            'statusCode': 400,
            'body': json.dumps("Error: 'directory_name' is required in the event payload.")
        }
        
    base_path = "/mnt/efs"

    new_directory_path = os.path.join(base_path, directory_name)
    os.makedirs(new_directory_path, exist_ok=True)
    list_directories = os.listdir(base_path)

    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': f"Directory '{directory_name}' created successfully at {new_directory_path}",
            'current_list_directories': list_directories,
            'received_event': event_body
        })
    }
