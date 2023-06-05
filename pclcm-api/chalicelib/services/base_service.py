from sqlalchemy.sql import func
from chalicelib.models.models import BaseMaster
from chalicelib.models import session
from chalicelib.utils.utils import add_update_object, object_as_dict, export, paginate
from chalicelib.messages import MessageResponse

message_base_constant = MessageResponse()
message_base_constant.setName("Base Master")


def add_base(base_obj):
    """
    Create request and add record for base.

    Argument:
        base_obj: request body
    Returns:
        The message.
    """
    create_base = BaseMaster()
    session.add(add_update_object(base_obj, create_base))
    session.commit()
    return (True, message_base_constant.MESSAGE_SUCCESS_CREATED)


def update_base_info(base_obj):
    """
    update 1 record for base by id.

    Arguments:
        base_obj: json body
    Returns:
        Response: Returning a message.
    """
    base_id = base_obj.get("baseId")
    if (
        update_to_base := session.query(BaseMaster)
        .filter(BaseMaster.baseId == base_id, BaseMaster.isDeleted == False)
        .first()
    ):

        add_update_object(base_obj, update_to_base)
        update_to_base.modifiedAt = func.now()
        session.commit()
        return (True, message_base_constant.MESSAGE_SUCCESS_UPDATED)
    return (False, message_base_constant.MESSAGE_ERROR_NOT_EXIST)


def delete_base(query_params):
    """
    Delete 1 record for base by id.

    Argument:
        query_params: parameter
    Returns:
        The message.
    """
    base_id = query_params.get("baseId")
    if (
        delete_to_base := session.query(BaseMaster)
        .filter(BaseMaster.baseId == base_id, BaseMaster.isDeleted == False)
        .first()
    ):
        delete_to_base.isDeleted = True
        delete_to_base.deletedAt = func.now()
        return (True, message_base_constant.MESSAGE_SUCCESS_DELETED)
    return (False, message_base_constant.MESSAGE_ERROR_NOT_EXIST)


def get_base_info(query_params):
    """
    get 1 record for base by id.

    Arguments:
        query_params: param search
    Returns:
        Response: Returning a message and a object include obj arrivalInfo, obj itemInfo, obj orderInfo and obj procurementInfo.
    """
    base_id = query_params.get("baseId")
    if (
        base_info := session.query(BaseMaster)
        .filter(BaseMaster.baseId == base_id)
        .first()
    ):
        tmp_base_info = {
            **object_as_dict(base_info, True),
            "message": message_base_constant.MESSAGE_SUCCESS_GET_INFO,
            "status": 200
        }
        return (True, tmp_base_info)
    return (False, message_base_constant.MESSAGE_ERROR_NOT_EXIST)


def get_base_list(query_params):
    """
    Get 1 or many record for base by params.

    Argument:
        query_params: param search
    Returns:
        Response: Returning a message, total record, lists.
    """
    filter_param_get_list = filter_param_get_list_base(query_params)
    paginated_lst = paginate(filter_param_get_list, query_params)
    return (True, {"mstBase": paginated_lst,
                   "total": len(filter_param_get_list),
                   "message": message_base_constant.MESSAGE_SUCCESS_GET_LIST,
                   "status": 200})


def export_base_list(query_params):
    return export(filter_param_get_list_base(query_params))


def filter_param_get_list_base(query_params):
    """
    Query and search base with parameters

    Arguments:
        query_params: param search
    Returns:
        List: Returning a list object.
    """
    # Query Column needs to get, join tables containing information to get
    query_list_base = session.query(BaseMaster)
    if query_params:
        params_search_base = ["baseId", "prefCode"]
        # Search for params that exist in BaseMaster
        for param in params_search_base:
            if param in query_params:
                query_list_base = query_list_base.filter(
                    getattr(BaseMaster, param) == query_params[param]
                )
        # Search Base with baseName
        if "baseName" in query_params:
            query_list_base = query_list_base.filter(
                BaseMaster.baseName.like(f"%{query_params['baseName']}%")
            )
        # If deleted record display mode is "0", search the record has not been deleted
        if query_params.get("deletedRecordDisplayMode") == "0":
            query_list_base = query_list_base.filter(BaseMaster.isDeleted == 0)
    else:
        query_list_base = query_list_base.filter(BaseMaster.isDeleted == 0)

    return [object_as_dict(base) for base in query_list_base.all()]
