import json
import boto3

client = boto3.client('lambda')

def lambda_handler(event, context):
    inputForInvoke = {'CustomerId': '123', 'Amount': 50 }
    
    response = client.invoke(
        FunctionName='ARN',  # name or ARN
        InvocationType='RequestResponse', # Event
        Payload=json.dumps(inputForInvoke)
    )
    
    responseJson = json.load(response['Payload'])
    
    print('\n')
    print(responseJson)
    print('\n')