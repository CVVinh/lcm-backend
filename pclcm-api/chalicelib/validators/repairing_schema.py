import jsonschema

from chalicelib.exceptions.custom_exception import ApplicationException
from chalicelib.messages import Message
from chalicelib.utils import LOGGER
from chalicelib.utils.utils import check_param_error


def validate_repair_list(json_body):
    try:
        jsonschema.validate(json_body, repair_list_schema)
    except Exception as e:
        LOGGER.debug(e)
        raise ApplicationException(message=Message.E000002.format(
            check_param_error(e, repair_list_schema)))


repair_list_schema = {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "type": "object",
    "properties": {
        "repairingId": {"type": "integer"},
        "assetId": {"type": "integer"},
        "accountId": {"type": "integer"},
        "outsourcingCompanyId": {"type": "integer"},
        "repairingStatus": {"type": "integer"}
    },
    "required": []
}
