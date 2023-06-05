from sqlalchemy.sql import func
from chalicelib.models.models import MakerMaster
from chalicelib.models import session
from chalicelib.utils.utils import add_update_object, paginate, object_as_dict, export
from chalicelib.messages import MessageResponse

message_maker_constant = MessageResponse()
message_maker_constant.setName("Maker Master")


def filter_param_get_list_maker(query_params):
    """
    Filter list maker according to the parameter.

    Argument:
        query_params: parameter
    Returns:
        The object.
    """
    query_list_maker = session.query(MakerMaster)
    # If any Param exists, then search. In contrast, search the record has not been deleted
    if query_params:
        maker_params = ["makerId", "area"]
        # Search for params that exist in MakerMaster
        for param in query_params.keys() & set(maker_params):
            query_list_maker = query_list_maker.filter(
                getattr(MakerMaster, param) == query_params[param]
            )
        # Search maker name in query params, find the value with "makerName" in any position
        if "makerName" in query_params:
            query_list_maker = query_list_maker.filter(
                MakerMaster.makerName.like(
                    f"%{query_params.get('makerName')}%")
            )
        # Search record not deleted
        if query_params.get("deletedRecordDisplayMode") == "0":
            query_list_maker = query_list_maker.filter(
                MakerMaster.isDeleted == 0
            )
    else:
        query_list_maker = query_list_maker.filter(
            MakerMaster.isDeleted == 0
        )
    result_list = []
    # Create loop of lists maker, assign it to an object and then assign to a new list.
    for maker in query_list_maker.all():
        # Join in prefecture
        join_pref = maker.prefecture
        # Create filed address
        address_list = []
        [
            address_list.append(arr_addr)
            for arr_addr in [
                maker.building,
                maker.street,
                maker.city,
                join_pref.prefName,
            ]
            if arr_addr not in [None, ""]
        ]
        tmp_maker = object_as_dict(maker)
        tmp_maker["address"] = "　".join(address_list)
        result_list.append(tmp_maker)

    return result_list


def get_maker_list(query_params):
    """
    Get 1 or many maker list by param.

    Argument:
        query_params: parameter
    Returns:
        The message, total and a list.
    """
    filter_param_get_list = filter_param_get_list_maker(query_params)
    # Paginate by pageNum & pageSize
    paginated_lst = paginate(filter_param_get_list, query_params)
    return (True, {"mstMakerMaster": paginated_lst,
                   "total": len(filter_param_get_list),
                   "message": message_maker_constant.MESSAGE_SUCCESS_GET_LIST,
                   "status": 200})


def add_maker(maker_obj):
    """
    Create request and add record for maker.

    Argument:
        maker_obj: request body
    Returns:
        The message.
    """
    create_maker = MakerMaster()
    session.add(add_update_object(maker_obj, create_maker))
    session.commit()
    return (True, message_maker_constant.MESSAGE_SUCCESS_CREATED)


def update_maker_info(maker_obj):
    """
    Update 1 record for maker by id.

    Argument:
        maker_obj: request body
    Returns:
        The message.
    """
    update_to_maker = session.query(MakerMaster).filter(
        MakerMaster.makerId == maker_obj.get("makerId"), MakerMaster.isDeleted == False).first()
    # If MakerMaster do exists, update maker and return a message
    if update_to_maker is not None:
        add_update_object(maker_obj, update_to_maker)
        update_to_maker.modifiedAt = func.now()
        session.commit()
        return (True, message_maker_constant.MESSAGE_SUCCESS_UPDATED)
    return (False, message_maker_constant.MESSAGE_ERROR_NOT_EXIST)


def get_maker_info(query_params):
    """
    Get 1 record for maker by id.

    Argument:
        query_params: parameter
    Returns:
        The message and 1 object maker.
    """
    maker_id = query_params.get("makerId")
    maker_info = session.query(MakerMaster).filter(
        MakerMaster.makerId == maker_id).first()
    # If MakerMaster dose not exists, return a message
    if maker_info is None:
        return (False, message_maker_constant.MESSAGE_ERROR_NOT_EXIST)
    tmp_maker_info = object_as_dict(maker_info, True)
    tmp_maker_info["message"] = message_maker_constant.MESSAGE_SUCCESS_GET_INFO
    tmp_maker_info["status"] = 200
    return (True, tmp_maker_info)


def delete_maker(query_params):
    """
    Delete 1 record for maker by id.

    Argument:
        query_params: parameter
    Returns:
        The message.
    """
    maker_id = query_params.get("makerId")
    delete_to_maker = session.query(MakerMaster).filter(
        MakerMaster.makerId == maker_id, MakerMaster.isDeleted == False).first()
    # If MakerMaster dose not exists, return a message
    if delete_to_maker is None:
        return (False, message_maker_constant.MESSAGE_ERROR_NOT_EXIST)
    join_item_master = delete_to_maker.itemMaster
    # Check MakerMaster exists in another table
    if join_item_master is None or join_item_master.isDeleted == True:
        delete_to_maker.isDeleted = True
        delete_to_maker.deletedAt = func.now()
        return (True, message_maker_constant.MESSAGE_SUCCESS_DELETED)
    return (False, message_maker_constant.MESSAGE_ERROR_TABLE_EXIST)


def export_maker_list(query_params):
    """
    Export 1 or many record for maker by param.

    Argument:
        request: parameter
    Returns:
        The csv.
    """
    # Export list maker
    return export(filter_param_get_list_maker(query_params))
