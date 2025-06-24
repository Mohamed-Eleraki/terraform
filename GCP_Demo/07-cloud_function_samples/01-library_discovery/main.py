import flask
import flask.typing
import functions_framework


@functions_framework.http  # functions_framework decoration, tells Google Cloud Functions
# that this function (hello) should be triggered by HTTP requests.
def hello(request: flask.Request) -> flask.typing.ResponseReturnValue:
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object. The request object contains
            the HTTP request data.
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
    """
    return "Hello World!"
