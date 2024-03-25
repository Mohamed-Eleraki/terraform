import json
import uuid

def lambda_handler(event, context):
    
    # Read off the input arguments
    customerId = event['CustomerId']
    
    # Generate random id
    transactionId = str(uuid.uuid1())
    
    # do some stuff i.e. save to s3, write to database, etc
    
    
    # format and return resonse
    return  {'CustomerId': customerId, 'Success': 'true', 'TransactionId': transactionId}