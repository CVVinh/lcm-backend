from chalicelib.models import session
from chalicelib.models.models import GenCode
from chalicelib.utils.utils import object_as_dict
from chalicelib.messages import MessageResponse

message_gen_code_constant = MessageResponse()
message_gen_code_constant.setName("Gen Code")


def filter_param_get_list_gen_code(query_params):
    """
    Query and search gen code with parameters

    Arguments:
        query_params: param search
    Returns:
        List: Returning a list object.
    """
    query_list_gen_code = session.query(GenCode)
    if query_params:
        params_search_gen_code = ["tableName", "fieldName"]

        # Search for params that exist in GenCode
        for param in params_search_gen_code:
            if param in query_params:
                query_list_gen_code = query_list_gen_code.filter(
                    getattr(GenCode, param) == query_params[param]
                )
    return [object_as_dict(gen_code) for gen_code in query_list_gen_code.all()]


def get_gen_code_list(query_params):
    """
    Get 1 or many record for gen code by params.

    Argument:
        query_params: param search
    Returns:
        Response: Returning a message, total record, lists.
    """
    return (True, {
        "mstGenCode": filter_param_get_list_gen_code(query_params),
        "msg": message_gen_code_constant.MESSAGE_SUCCESS_GET_LIST,
        "status": 200
    })
