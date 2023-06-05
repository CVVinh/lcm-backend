from chalicelib.models import session
from chalicelib.models.models import KittingMaster, Kitting
from chalicelib.utils.status_response import success_response, error_response
import datetime
from sqlalchemy.sql import func
from chalicelib.utils.utils import object_as_dict, add_update_object, paginate, export
from chalicelib.messages import MessageResponse

message_kitting_master_constant = MessageResponse()
message_kitting_master_constant.setName("Kitting Master")


def filter_param_get_kitting_list(query_params):
    """
    Filter list kitting master according to the parameter.

    Argument:
        query_params: parameter
    Returns:
        The object.
    """
    query_list_kitting_master = session.query(KittingMaster)

    if query_params:
        params_search_kitting_master = [
            "kittingMasterId", "masterPCNumber", "kittingMethod", "note"]
        # * Filter kitting search params
        for param in query_params:
            if param in params_search_kitting_master:
                query_list_kitting_master = query_list_kitting_master.filter(
                    getattr(KittingMaster, param) == query_params[param])

        # * Filter search by name
        if "kittingMasterName" in query_params:
            query_list_kitting_master = query_list_kitting_master.filter(
                KittingMaster.kittingMasterName.like(
                    f"%{query_params['kittingMasterName']}%"))

        if query_params.get("deletedRecordDisplayMode") == "0":
            query_list_kitting_master = query_list_kitting_master.filter(
                KittingMaster.isDeleted == 0)
    else:
        query_list_kitting_master = query_list_kitting_master.filter(
            KittingMaster.isDeleted == 0)

    return [{**object_as_dict(kitting_master)} for kitting_master in query_list_kitting_master.all()]


def get_kitting_list(query_params):
    """
    Get 1 or many kitting master list by param.

    Argument:
        query_params: parameter
    Returns:
        The message, total and a list.
    """
    filter_param_get_list = filter_param_get_kitting_list(query_params)
    # * Paginate by pageNum & pageSize
    paginated_lst = paginate(filter_param_get_list, query_params)

    return (True, {
        "kittingList": paginated_lst,
        "kittingTotal": len(filter_param_get_list),
        "msg": message_kitting_master_constant.MESSAGE_SUCCESS_GET_LIST,
        "status": 200,
    })


def export_kitting_list(query_params):
    # * Print dict
    return export(filter_param_get_kitting_list(query_params))


def add_kitting(kitting_master_obj):
    """
    Create request and add record for kitting master.

    Argument:
        kitting_master_obj: request body
    Returns:
        The message.
    """
    create_kitting_master = KittingMaster()

    session.add(add_update_object(kitting_master_obj, create_kitting_master))
    session.commit()

    return (True, message_kitting_master_constant.MESSAGE_SUCCESS_CREATED)


def update_kitting(kitting_master_obj):
    """
    Update 1 record for kitting master by id.

    Argument:
        kitting_master_obj: request body
    Returns:
        The message.
    """
    update_m_kitting = session.query(KittingMaster).filter(
        KittingMaster.kittingMasterId == kitting_master_obj["kittingMasterId"], KittingMaster.isDeleted == 0).first()

    if update_m_kitting is None:
        return (False, message_kitting_master_constant.MESSAGE_ERROR_NOT_EXIST)

    add_update_object(kitting_master_obj, update_m_kitting)
    update_m_kitting.modifiedAt = func.now()
    session.commit()
    return (True, message_kitting_master_constant.MESSAGE_SUCCESS_UPDATED)


def get_kitting_master_info(query_params):
    """
    Get 1 record for kitting master by id.

    Argument:
        query_params: parameter
    Returns:
        The message and 1 object kitting master.
    """
    kitting_master_id: int = query_params.get("kittingMasterId")
    kitting_master = session.query(KittingMaster).filter(
        KittingMaster.kittingMasterId == kitting_master_id).first()
    if kitting_master is None:
        return (False, message_kitting_master_constant.MESSAGE_ERROR_NOT_EXIST)

    return (True, {
            "kittingMasterInfo": object_as_dict(kitting_master, True),
            "msg": message_kitting_master_constant.MESSAGE_SUCCESS_GET_INFO,
            "status": 200
            })


def delete_kitting(query_params):
    """
    Delete 1 record for kitting master by id.

    Argument:
        query_params: parameter
    Returns:
        The message.
    """
    kitting_master_id: int = query_params.get("kittingMasterId")
    del_kitting = session.query(KittingMaster).filter(
        KittingMaster.kittingMasterId == kitting_master_id, KittingMaster.isDeleted == False).first()

    if del_kitting is None:
        return (False, message_kitting_master_constant.MESSAGE_ERROR_NOT_EXIST)
    if del_kitting.asset or del_kitting.order:
        return (False, message_kitting_master_constant.MESSAGE_ERROR_TABLE_EXIST)

    del_kitting.isDeleted = 1
    del_kitting.deletedAt = func.now()
    session.commit()
    return (True, message_kitting_master_constant.MESSAGE_SUCCESS_DELETED)
