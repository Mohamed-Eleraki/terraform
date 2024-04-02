def lambda_handler(event, context):
    message =   'Hello {} {}!'.format(event['first_name'], event['last_name'])
    
    return {
        'message': message
    }
    
    # Handler name >> 1_filename.lambda_handler | you have the ability to change it.
    # event pass values >> pass the first_name and the last_name as below as an event invoker
    #     {
    #         "first_name": "Mohamed",
    #         "last_name": "Taha"
    #     }