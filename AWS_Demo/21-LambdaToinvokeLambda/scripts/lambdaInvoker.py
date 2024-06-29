import boto3
import json

client = boto3.client('lambda')

def lambda_handler(event, context):
    inputForInvoker = {'CustomerId': '123', 'Amount': '50'}
    
    response = client.invoke(
        FunctionName = 'lambda_to_invoke',
        InvocationType = 'RequestResponse',  # synchronous = RequestResponse, Asynchronous = Event
        Payload = json.dumps(inputForInvoker)
    )
    
    # get the lambdatoInvoke response that stored at Payload key
    responseJson = json.load(response['Payload'])
    
    print(responseJson)