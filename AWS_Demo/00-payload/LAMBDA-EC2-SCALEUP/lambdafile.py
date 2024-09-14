import boto3
 
def lambda_handler(event, context):
    ec2_client = boto3.client('ec2')
 
    # EC2 instance ID (replace with your instance ID)
    instance_id = 'i-0f2f37e298cc88947'  # Your EC2 instance ID
 
    # Desired instance type to scale up
    new_instance_type = 't3a.medium'
 
    try:
        # Stop the instance before modifying its type
        ec2_client.stop_instances(InstanceIds=[instance_id])
        print(f"Stopping instance {instance_id}...")
 
        # Wait until the instance is stopped
        waiter = ec2_client.get_waiter('instance_stopped')
        waiter.wait(InstanceIds=[instance_id])
        print(f"Instance {instance_id} stopped.")
 
        # Modify the instance type
        ec2_client.modify_instance_attribute(InstanceId=instance_id, Attribute='instanceType', Value=new_instance_type)
        print(f"Instance {instance_id} type changed to {new_instance_type}.")
 
        # Start the instance after modifying its type
        ec2_client.start_instances(InstanceIds=[instance_id])
        print(f"Starting instance {instance_id}...")
 
    except Exception as e:
        print(f"Error scaling up instance {instance_id}: {e}")
        raise e
 
    return {
        'statusCode': 200,
        'body': f"Successfully scaled up instance {instance_id} to {new_instance_type}"
    }