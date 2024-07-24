import boto3

def lambda_handler(event, context):
    
    ec_client = boto3.client('ec2', region_name="us-east-1")
    all_availabel_vpcs = ec_client.descript_vpcs()
    vpcs = all_availabel_vpcs["Vpcs"]
    
    try:
        for vpc in vpcs:
            vpc_id = vpc["VpcId"]
            cidr_block = vpc["CiderBlock"]
            state = vpc["State"]
            
            print(f"VPC ID: {vpc_id} with {cider_block} state: {state}")
            
    except Exception as error:
        print(f"Error occured: {error}")