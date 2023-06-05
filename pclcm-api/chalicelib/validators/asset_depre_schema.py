import jsonschema

from chalicelib.exceptions.custom_exception import ApplicationException
from chalicelib.messages import Message
from chalicelib.utils import LOGGER
from chalicelib.utils.utils import check_param_error


def validate_asset_depre_post(json_body):
    try:
        jsonschema.validate(json_body, asset_depre_post_schema)
    except Exception as e:
        LOGGER.debug(e)
        raise ApplicationException(message=Message.E000002.format(
            check_param_error(e, asset_depre_post_schema)))


asset_depre_post_schema = {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "type": "object",
    "properties": {
        "assetId": {"type": "integer", "minLength": 1},
        "depreciationRuleId": {"type": "integer", "minLength": 1},
    },
    "required": [
    ]
}
