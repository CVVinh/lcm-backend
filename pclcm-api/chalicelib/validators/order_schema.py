import jsonschema
from chalicelib.exceptions.custom_exception import ApplicationException
from chalicelib.messages import Message
from chalicelib.utils import LOGGER
from chalicelib.utils.utils import check_param_error

def validate_order_list(json_body):
    try:
        jsonschema.validate(json_body, order_list_schema)
        
    except Exception as e:
        LOGGER.debug(e)
        raise ApplicationException(message=Message.E000002.format(check_param_error(e, order_list_schema)))

order_list_schema = {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "type": "object",
    "properties":{
        "orderId": {"type": ["integer"],},
        "companyOrder": {"type": ["string"],},
        "addressOrder": {"type": ["string"],},
        "descriptionOrder": {"type": ["string"],},
    },
    "required": []
}















