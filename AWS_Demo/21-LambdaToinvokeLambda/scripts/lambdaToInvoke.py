import json
import uuid

def lambda_handler(event, context):
    
    # 1 - Read of the input arrgument
    customerId = event['CustomerId']
    
    # 2 - Generate a random id
    transactionId = str(uuid.uuid1())
    
    # Format and return response
    return {'CustomerId': customerId, 'Success': 'true', 'TransactionId': transactionId}
    
