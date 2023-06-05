import select
from chalicelib.models import session
from chalicelib.models.models import Message, Userrequest, AccountMaster, GroupMaster, Asset
from chalicelib.utils.status_response import success_response, error_response
import datetime
from chalicelib.utils.utils import object_as_dict
import csv
import json
from chalicelib.messages import MessageResponse

message_user_request_constant = MessageResponse()
message_user_request_constant.setName("User Request")
message_message_constant = MessageResponse()
message_message_constant.setName("Message")

# メッセージ


def get_message_list():
    query = session.query(Message)

    request_list_db = query.all()

    results = []
    for request in request_list_db:
        account_master = request.accountMaster
        tmp = {
            'messageId': request.messageId,
            'message': request.message,
            'title': request.title,
            # 'created_datetime': request.created_datetime,
            'accountName': account_master.accountName,
        }
        results.append(tmp)
    return success_response(
        {
            "mstmessage": results,
            "messageTotal": len(results),
            "msg": message_message_constant.MESSAGE_SUCCESS_GET_LIST,
        }
    )

# 申請


def get_request_list(query_params):
    query_set = session.query(Userrequest)

    if query_params:
        # filter params from front-end
        equal_params = ["requestId", "requestMenu", "accountId", "groupId"]
        for param in query_params:
            if param in equal_params:
                query_set = query_set.filter(
                    getattr(Userrequest, param) == query_params[param]
                )

    request_list_db = query_set.all()

    results = []
    for request in request_list_db:
        account_master = request.accountMaster
        requestaccount_master = request.requestaccountMaster
        group_master = request.groupMaster
        asset = request.asset
        tmp = {
            'requestId': request.requestId,
            'assetId': request.assetId,
            'accountId': request.accountId,
            'groupId': request.groupId,
            'assetName': asset.assetNameKana,
            'accountName': account_master.accountName,
            'groupName': group_master.groupName,
            'requestMenu': request.requestMenu,
            'requestDatetime': "",
            'requestAccountName': requestaccount_master.accountName,
            # 'request_completion_date': request.request_completion_date(),
        }
        results.append(tmp)

    return ({
        "mstrequest": results,
        "requestTotal"
        "msg": message_user_request_constant.MESSAGE_SUCCESS_GET_LIST
    })


def get_request_info(requestId: int):
    resp_request = session.query(Userrequest).filter(
        Userrequest.requestId == requestId).first()

    accountName = object_as_dict(resp_request.accountMaster)["accountName"]
    requestaccountName = object_as_dict(
        resp_request.requestaccountMaster)["accountName"]
    assetName = object_as_dict(resp_request.asset)["assetNameKana"]
    groupName = object_as_dict(resp_request.groupMaster)["groupName"]
    requestgroupName = object_as_dict(
        resp_request.requestgroupMaster)["groupName"]
    assetstatus = object_as_dict(resp_request.asset)["assetStatus"]
    #useFrom = object_as_dict(resp_request.use)["use_on_from"]

    result = object_as_dict(resp_request)
    result["accountName"] = accountName
    result["requestAccountName"] = requestaccountName
    result["assetName"] = assetName
    result["groupName"] = groupName
    result["requestGroupName"] = requestgroupName
    result["assetStatus"] = assetstatus
    #result["use_on_from"] = useFrom
    return success_response({"requestInfo": result, "msg": message_user_request_constant.MESSAGE_SUCCESS_GET_INFO})


def add_request(data):
    create_item = Userrequest()

    session.add(create_item)
    session.commit()
    return success_response({"msg": message_user_request_constant.MESSAGE_SUCCESS_CREATED, "status": 200})
