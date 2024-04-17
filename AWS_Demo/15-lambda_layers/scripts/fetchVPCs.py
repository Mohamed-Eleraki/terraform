import boto3

def lambda_handler(event, context):

    ec_client = boto3.client('ec2', region_name="us-east-1")
    all_available_vpcs = ec_client.describe_vpcs()
    vpcs = all_available_vpcs["Vpcs"]

    try:
        # looping
        for vpc in vpcs:
            vpc_id = vpc["VpcId"]
            cidr_block = vpc["CidrBlock"]
            state = vpc["State"]

            print(f"VPC ID: {vpc_id} with {cidr_block} state = {state}")

    except Exception as error:
        print(f"Error occurred: {error}")
