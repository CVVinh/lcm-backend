from chalicelib.models import session
from chalicelib.models.models import Prefecture
from chalicelib.messages import MessageResponse

message_prefecture_constant = MessageResponse()
message_prefecture_constant.setName("Prefecture")


def get_prefecture_list(query_params):
    """
    Get all record for prefecture by params.

    Argument:
        query_params: param search
    Returns:
        Response: Returning a message, lists.
    """
    list_prefecture_master = session.query(Prefecture).all()

    prefecture_list = []
    for prefecture in list_prefecture_master:
        tmp_prefecture = {
            'prefId': prefecture.prefId,
            'prefName': prefecture.prefName
        }
        prefecture_list.append(tmp_prefecture)

    return (True, {
        "mstPrefecture": prefecture_list,
        "msg": message_prefecture_constant.MESSAGE_SUCCESS_GET_LIST,
        "status": 200
    })
