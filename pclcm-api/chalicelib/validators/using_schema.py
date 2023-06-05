import jsonschema

from chalicelib.exceptions.custom_exception import ApplicationException
from chalicelib.messages import Message
from chalicelib.utils import LOGGER
from chalicelib.utils.utils import check_param_error


def validate_post_using_list(json_body):
    try:
        jsonschema.validate(json_body, post_using_list_schema)
    except Exception as e:
        LOGGER.debug(e)
        raise ApplicationException(message=Message.E000002.format(
            check_param_error(e, post_using_list_schema)))


def validate_put_using_list(json_body):
    try:
        jsonschema.validate(json_body, put_using_list_schema)
    except Exception as e:
        LOGGER.debug(e)
        raise ApplicationException(message=Message.E000002.format(
            check_param_error(e, put_using_list_schema)))


post_using_list_schema = {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "type": "object",
    "properties": {
        "assetId": {"type": "integer", "minLength": 1},
        "accountId": {"type": "integer", "minLength": 1},
        "useOnFrom": {"type": ["string", "null"], "pattern": "(((19|20)([2468][048]|[13579][26]|0[48])|2000)[/-]02[/-]29|((19|20)[0-9]{2}[/-](0[469]|11)[/-](0[1-9]|[12][0-9]|30)|(19|20)[0-9]{2}[/-](0[13578]|1[02])[/-](0[1-9]|[12][0-9]|3[01])|(19|20)[0-9]{2}[/-]02[/-](0[1-9]|1[0-9]|2[0-8])))"},
        "useOnTo": {"type": ["string", "null"], "pattern": "(((19|20)([2468][048]|[13579][26]|0[48])|2000)[/-]02[/-]29|((19|20)[0-9]{2}[/-](0[469]|11)[/-](0[1-9]|[12][0-9]|30)|(19|20)[0-9]{2}[/-](0[13578]|1[02])[/-](0[1-9]|[12][0-9]|3[01])|(19|20)[0-9]{2}[/-]02[/-](0[1-9]|1[0-9]|2[0-8])))"},
        "groupId": {"type": ["integer", "null"], "minLength": 1},
        "baseId": {"type": ["integer", "null"], "minLength": 1},
        "usingFrom": {
            "type": ["string", "null"],
            "pattern": "(((19|20)([2468][048]|[13579][26]|0[48])|2000)[/-]02[/-]29|((19|20)[0-9]{2}[/-](0[469]|11)[/-](0[1-9]|[12][0-9]|30)|(19|20)[0-9]{2}[/-](0[13578]|1[02])[/-](0[1-9]|[12][0-9]|3[01])|(19|20)[0-9]{2}[/-]02[/-](0[1-9]|1[0-9]|2[0-8])))"
        },
        "usingTo": {
            "type": ["string", "null"],
            "pattern": "(((19|20)([2468][048]|[13579][26]|0[48])|2000)[/-]02[/-]29|((19|20)[0-9]{2}[/-](0[469]|11)[/-](0[1-9]|[12][0-9]|30)|(19|20)[0-9]{2}[/-](0[13578]|1[02])[/-](0[1-9]|[12][0-9]|3[01])|(19|20)[0-9]{2}[/-]02[/-](0[1-9]|1[0-9]|2[0-8])))"
        },
    },
    "required": ["assetId", "accountId"]
}

put_using_list_schema = {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "type": "object",
    "properties": {
        "assetId": {"type": "integer", "minLength": 1},
        "accountId": {"type": "integer", "minLength": 1},
        "useOnFrom": {"type": ["string", "null"], "pattern": "(((19|20)([2468][048]|[13579][26]|0[48])|2000)[/-]02[/-]29|((19|20)[0-9]{2}[/-](0[469]|11)[/-](0[1-9]|[12][0-9]|30)|(19|20)[0-9]{2}[/-](0[13578]|1[02])[/-](0[1-9]|[12][0-9]|3[01])|(19|20)[0-9]{2}[/-]02[/-](0[1-9]|1[0-9]|2[0-8])))"},
        "useOnTo": {"type": ["string", "null"], "pattern": "(((19|20)([2468][048]|[13579][26]|0[48])|2000)[/-]02[/-]29|((19|20)[0-9]{2}[/-](0[469]|11)[/-](0[1-9]|[12][0-9]|30)|(19|20)[0-9]{2}[/-](0[13578]|1[02])[/-](0[1-9]|[12][0-9]|3[01])|(19|20)[0-9]{2}[/-]02[/-](0[1-9]|1[0-9]|2[0-8])))"},
        "groupId": {"type": ["integer", "null"], "minLength": 1},
        "baseId": {"type": ["integer", "null"], "minLength": 1},
        "useStatus": {"type": "integer"}
    },
    "required": []
}
