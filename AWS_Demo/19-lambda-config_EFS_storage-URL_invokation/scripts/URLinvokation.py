import json
import os

def lambda_handler(event, context):
    directory_name = event.get("directory_name", "default_dir")
    base_path = "/mnt/efs"

    new_directory_path = os.path.join(base_path, directory_name)
    os.makedirs(new_directory_path, exist_ok=True)
    list_directories = os.listdir(base_path)

    return {
        'statusCode': 200,
        'body': json.dumps(f"Directory {directory_name} created successfully at {new_directory_path}, Current list directories are: {list_directories}")
    }
