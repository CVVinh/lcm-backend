from chalicelib.models import session
from chalicelib.models.models import OutsourcingCompanyMaster
from sqlalchemy.sql import func
from chalicelib.utils.utils import add_update_object, paginate, object_as_dict, export
from chalicelib.messages import MessageResponse

message_outsourcing_company_constant = MessageResponse()
message_outsourcing_company_constant.setName("Outsourcing Company Master")


def filter_param_get_list_outsourcing_company(query_params):
    """
    Filter list outsourcing company according to the parameter.

    Argument:
        query_params: parameter
    Returns:
        The list.
    """
    query_list_outsourcing_company = session.query(OutsourcingCompanyMaster)
    # If any Param exists, then search. In contrast, search the record has not been deleted
    if query_params:
        outsourcing_company_params = ["outsourcingCompanyId", "area"]
        # Search for params that exist in ItemSet
        for param in query_params.keys() & set(outsourcing_company_params):
            query_list_outsourcing_company = query_list_outsourcing_company.filter(
                getattr(OutsourcingCompanyMaster, param) == query_params[param]
            )
        # Search outsourcing company name in query params, find the value with "outsourcingCompanyName" in any position
        if "outsourcingCompanyName" in query_params:
            query_list_outsourcing_company = query_list_outsourcing_company.filter(
                OutsourcingCompanyMaster.outsourcingCompanyName.like(
                    f"%{query_params.get('outsourcingCompanyName')}%")
            )
        # Search record not deleted
        if query_params.get("deletedRecordDisplayMode") == "0":
            query_list_outsourcing_company = query_list_outsourcing_company.filter(
                OutsourcingCompanyMaster.isDeleted == 0
            )
    else:
        query_list_outsourcing_company = query_list_outsourcing_company.filter(
            OutsourcingCompanyMaster.isDeleted == 0
        )
    result_list = []
    # Create loop of lists outsourcing company, assign it to an object and then assign to a new list.
    for outsourcing_company in query_list_outsourcing_company.all():
        # Join in prefecture
        join_pref = outsourcing_company.prefecture
        # Create filed address
        address = []
        [
            address.append(arr)
            for arr in [
                outsourcing_company.building,
                outsourcing_company.street,
                outsourcing_company.city,
                join_pref.prefName,
            ]
            if arr not in [None, ""]
        ]
        tmp_maker = object_as_dict(outsourcing_company)
        tmp_maker["address"] = "　".join(address)
        result_list.append(tmp_maker)
    return result_list


def get_outsourcing_company_list(query_params):
    """
    Get 1 or many outsourcing company list by param.

    Argument:
        query_params: parameter
    Returns:
        The message, total and a list.
    """
    filter_param_get_list = filter_param_get_list_outsourcing_company(
        query_params)
    # Paginate by pageNum & pageSize
    paginated_lst = paginate(filter_param_get_list, query_params)
    return (True, {
        "mstOutsourcingCompanyMaster": paginated_lst,
        "total": len(filter_param_get_list),
        "message": message_outsourcing_company_constant.MESSAGE_SUCCESS_GET_LIST,
        "status": 200})


def add_outsourcing_company(outsourcing_company_obj):
    """
    Create request and add record for outsourcing company.

    Argument:
        outsourcing_company_obj: request body
    Returns:
        The message.
    """
    create_outsourcing_company = OutsourcingCompanyMaster()
    session.add(add_update_object(
        outsourcing_company_obj, create_outsourcing_company))
    session.commit()
    return (True, message_outsourcing_company_constant.MESSAGE_SUCCESS_CREATED)


def update_outsourcing_company(outsourcing_company_obj):
    """
    Update 1 record for outsourcing company by id.

    Argument:
        outsourcing_company_obj: request body
    Returns:
        The message.
    """
    update_to_outsourcing_company = session.query(OutsourcingCompanyMaster).filter(
        OutsourcingCompanyMaster.outsourcingCompanyId == outsourcing_company_obj.get(
            "outsourcingCompanyId"),
        OutsourcingCompanyMaster.isDeleted == False).first()

    # Check outsourcing company exists
    if update_to_outsourcing_company is not None:
        add_update_object(outsourcing_company_obj,
                          update_to_outsourcing_company)
        update_to_outsourcing_company.modifiedAt = func.now()
        session.commit()
        return (True, message_outsourcing_company_constant.MESSAGE_SUCCESS_UPDATED)
    return (False, message_outsourcing_company_constant.MESSAGE_ERROR_NOT_EXIST)


def get_outsourcing_company_info(query_params):
    """
    Get 1 record for outsourcing company by id.

    Argument:
        request: parameter
    Returns:
        The message and 1 object outsourcing company.
    """
    outsourcing_company_id = query_params.get("outsourcingCompanyId")
    outsourcing_company_info = session.query(OutsourcingCompanyMaster).filter(
        OutsourcingCompanyMaster.outsourcingCompanyId == outsourcing_company_id).first()

    if outsourcing_company_info is None:
        return (False, message_outsourcing_company_constant.MESSAGE_ERROR_NOT_EXIST)
    tmp_outsourcing_company = object_as_dict(outsourcing_company_info, True)
    tmp_outsourcing_company["message"] = message_outsourcing_company_constant.MESSAGE_SUCCESS_GET_INFO
    tmp_outsourcing_company["status"] = 200
    return (True, tmp_outsourcing_company)


def delete_outsourcing_company(query_params):
    """
    Delete 1 record for outsourcing company by id.

    Argument:
        query_params: parameter
    Returns:
        The message.
    """
    outsourcing_company_id = query_params.get("outsourcingCompanyId")
    delete_to_outsourcing_company = session.query(OutsourcingCompanyMaster).filter(
        OutsourcingCompanyMaster.outsourcingCompanyId == outsourcing_company_id,
        OutsourcingCompanyMaster.isDeleted == False).first()

    if delete_to_outsourcing_company is None:
        return (False, message_outsourcing_company_constant.MESSAGE_ERROR_NOT_EXIST)

    join_shipping = delete_to_outsourcing_company.shipping
    join_pick_up = delete_to_outsourcing_company.pickUp
    # Check outsourcingCompanyId exists in another table
    if (join_shipping is None or join_shipping.isDeleted == True) and (join_pick_up is None or join_pick_up.isDeleted == True):
        delete_to_outsourcing_company.isDeleted = True
        delete_to_outsourcing_company.deletedAt = func.now()
        return (True, message_outsourcing_company_constant.MESSAGE_SUCCESS_DELETED)
    return (False, message_outsourcing_company_constant.MESSAGE_ERROR_TABLE_EXIST)


def export_outsourcing_company_list(query_params):
    """
    Export 1 or many record for outsourcing company by param.

    Argument:
        query_params: parameter
    Returns:
        The csv.
    """
    # Export list outsourcing company
    return export(filter_param_get_list_outsourcing_company(query_params))
