from operator import and_
from chalicelib.models import session
from chalicelib.models.models import (
    Shipping, Asset, GroupMaster, AccountMaster, AccountGroupMaster, Order, Arrival)
from datetime import datetime
import time
from sqlalchemy.sql import func
from chalicelib.utils.utils import (
    check_operation_status, object_as_dict, add_update_object,
    paginate, export, format_day_and_bool_dict, get_list_asset_is_set, check_is_main_is_set)
from chalicelib.gen_codes import GenCodeConstant
from chalicelib.messages import MessageResponse

gen_code_constant = GenCodeConstant()
message_shipping_constant = MessageResponse()
message_shipping_constant.setName("Shipping")


def change_using_date_asset(shipping_obj):
    asset_id = shipping_obj.get("assetId")
    using_from = shipping_obj.get("usingFrom") or None
    using_to = shipping_obj.get("usingTo") or None
    query_asset = session.query(Asset).filter(
        Asset.assetId == asset_id).first()
    if using_from and using_to:
        # Update using from and using to into Asset
        query_asset.usingFrom = using_from
        query_asset.usingTo = using_to
    return query_asset


def create_shipping(shipping_obj):
    """
    add record for shipping.

    Arguments:
        shipping_obj: json body
    Returns:
        Response: Returning a message.
    """
    shipping = Shipping()
    # If estimated shipping date exist
    if estimated_shipping_date := shipping_obj.get("estimatedShippingDate"):
        format_current_date = int(time.mktime(
            datetime.now().date().timetuple()))
        format_estimated_shipping_date = int(time.mktime(datetime.strptime(
            estimated_shipping_date, '%Y-%m-%d').date().timetuple()))
        # If current day bigger than the estimated shipping date, shipping late is late
        if format_current_date > format_estimated_shipping_date:
            shipping.shippingLate = True
    # If asset status is disposed and asset operation in another table, not created record
    if check_status := check_operation_status(shipping_obj):
        return (False, check_status.body.get("msg"))

    change_using_date_asset(shipping_obj)
    session.add(add_update_object(shipping_obj, shipping))
    session.commit()
    return (True, message_shipping_constant.MESSAGE_SUCCESS_CREATED)


def update_shipping(shipping_obj):
    """
    update 1 record for shipping by id.

    Arguments:
        shipping_obj: json body
    Returns:
        Response: Returning a message.
    """
    asset_id = shipping_obj.get("assetId")
    shipping_status = shipping_obj.get("shippingStatus")
    using_from = shipping_obj.get("usingFrom") or None
    using_to = shipping_obj.get("usingTo") or None
    check_exsit = session.query(Shipping).filter(
        Shipping.assetId == asset_id, Shipping.isDeleted == False).first()
    join_asset = check_exsit.asset
    # If Shipping is none exist, return a message
    if check_exsit is None:
        return (False, message_shipping_constant.MESSAGE_ERROR_NOT_EXIST)
    add_update_object(shipping_obj, check_exsit)

    if join_asset:
        join_asset.usingFrom = using_from
        join_asset.usingTo = using_to
    # If shipping status is shipping, update asset status is shipping
    if shipping_status == gen_code_constant.SHIPPING_STATUS_SHIPPING:
        join_asset.assetStatus = gen_code_constant.ASSET_STATUS_SHIPPING
        check_exsit.shippingReceptionStatus = gen_code_constant.SHIPPING_RECEPTION_STATUS_ACCEPTING
        check_exsit.workingOn = func.now()
    # If shipping status is completed, update asset status is using
    elif shipping_status == gen_code_constant.SHIPPING_STATUS_COMPLETED:
        join_asset.assetStatus = gen_code_constant.ASSET_STATUS_USING
        check_exsit.completedOn = func.now()

    change_using_date_asset(shipping_obj)
    check_exsit.modifiedAt = func.now()
    session.commit()
    return (True, message_shipping_constant.MESSAGE_SUCCESS_UPDATED)


def delete_shipping(query_params):
    """
    Delete 1 record for shipping by id.

    Argument:
        query_params: param search
    Returns:
        Response: Returning a message.
    """
    asset_id = query_params.get("assetId")
    check_exsit = session.query(Shipping).filter(
        Shipping.assetId == asset_id, Shipping.isDeleted == False).first()
    if check_exsit is None:
        return (False, message_shipping_constant.MESSAGE_ERROR_NOT_EXIST)
    # If shipping status is completed, Don't be deleted
    if check_exsit.shippingStatus == gen_code_constant.SHIPPING_STATUS_COMPLETED:
        return (False, message_shipping_constant.MESSAGE_ERROR_STATUS_COMPLETED_DELETED)

    check_exsit.isDeleted = True
    check_exsit.deletedAt = func.now()
    session.commit()
    return (True, message_shipping_constant.MESSAGE_SUCCESS_DELETED)


def get_shipping_info(query_params):
    """
    get 1 record for shipping by id.

    Arguments:
        query_params: param search
    Returns:
        Response: Returning a message and a object include: assetInfo, procurementInfo, accountInfo,
            groupInfo, outsourcingCompanyInfo, shippingInfo objects.
    """
    asset_id = query_params.get("assetId")
    check_exsit = session.query(Shipping).filter(
        Shipping.assetId == asset_id).first()
    # If asset is none exist, return a message
    if check_exsit is None:
        return (False, message_shipping_constant.MESSAGE_ERROR_NOT_EXIST)

    join_asset = check_exsit.asset
    join_order = check_exsit.asset.arrival.order
    join_procurement = join_order.procurement
    join_account = check_exsit.accountMaster
    join_outsourcing_ompany = check_exsit.outsourcingCompany
    query_group = session.query(GroupMaster).join(AccountGroupMaster).filter(
        AccountGroupMaster.groupId == GroupMaster.groupId, AccountGroupMaster.accountId == join_account.accountId).first()
    asset_info = object_as_dict(join_asset, True)
    asset_info.update(check_is_main_is_set(asset_id))
    asset_info["listAssets"] = get_list_asset_is_set(asset_id)
    tmp_shipping = {
        "assetInfo": asset_info,
        "procurementInfo": object_as_dict(join_procurement, True),
        "accountInfo": object_as_dict(join_account, True),
        "groupInfo": object_as_dict(query_group, True),
        "outsourcingCompanyInfo": object_as_dict(join_outsourcing_ompany, True),
        "shippingInfo": object_as_dict(check_exsit, True),
        "message": message_shipping_constant.MESSAGE_SUCCESS_GET_INFO,
        "status": 200
    }
    return (True, tmp_shipping)


def get_shipping_list(query_params):
    """
    Get 1 or many record for shipping by params.

    Argument:
        query_params: param search
    Returns:
        Response: Returning a message, total record, lists.
    """
    filter_param_get_list = filter_param_get_list_shipping(query_params)
    # Paginate by pageNum & pageSize
    paginated_lst = paginate(filter_param_get_list, query_params)
    return (True, {
        "shippingList": paginated_lst,
        "totalRecords": len(filter_param_get_list),
        "message": message_shipping_constant.MESSAGE_SUCCESS_GET_LIST,
        "status": 200
    })


def export_shipping_list_csv(query_params):
    return export(filter_param_get_list_shipping(query_params))


def filter_param_get_list_shipping(query_params):
    """
    Query and search shipping with parameters

    Arguments:
        query_params: param search
    Returns:
        List: Returning a list object.
    """
    # Query Column needs to get, join tables containing information to get
    query_list_shipping = session.query(Shipping.shippingId, Shipping.shippingStatus, Shipping.shippingLate, Shipping.accountId,
                                        Shipping.receptionOn, Shipping.workingOn, Shipping.completedOn, Shipping.assetId,
                                        Shipping.outsourcingCompanyId, Shipping.shippingReceptionType, Shipping.estimatedShippingDate,
                                        Order.orderId, Arrival.arrivalId, AccountMaster.accountName).join(
        Asset, Asset.assetId == Shipping.assetId, isouter=True).join(
        Arrival, Arrival.arrivalId == Asset.arrivalId, isouter=True).join(
        Order, Order.orderId == Arrival.orderId, isouter=True).join(
        AccountMaster, AccountMaster.accountId == Shipping.accountId, isouter=True)
    # If any Param exists, then search. In contrast, search the record has not been deleted
    if query_params:
        params_search_shipping = ["shippingStatus", "accountId",
                                  "shippingLate", "assetId", "shippingReceptionType"]
        params_search_completed_on = ["completedOnFrom", "completedOnTo"]
        # Search for params that exist in Shipping
        for param in params_search_shipping:
            if param in query_params:
                query_list_shipping = query_list_shipping.filter(
                    getattr(Shipping, param) == query_params[param]
                )
         # Search Arrival with completedOnFrom and completedOnTo
        for param_day in params_search_completed_on:
            if param_day in query_params:
                query_list_shipping = query_list_shipping.filter(and_(
                    Shipping.completedOn >= query_params["completedOnFrom"], Shipping.completedOn <= query_params["completedOnTo"])
                )
        # Search Arrival with orderId
        if "orderId" in query_params:
            query_list_shipping = query_list_shipping.filter(
                Order.orderId == query_params["orderId"]
            )
        # If deleted record display mode is "0", search the record has not been deleted
        if query_params.get("deletedRecordDisplayMode") == "0":
            query_list_shipping = query_list_shipping.filter(
                Shipping.isDeleted == 0)
    else:
        query_list_shipping = query_list_shipping.filter(
            Shipping.isDeleted == 0)

    result_list = []
    # Create loop of lists shipping, assign it to an object and then assign to a new list.
    for shipping in query_list_shipping.all():
        obj_shipping = {**shipping}
        # format type datetime.datetime to string and bool to integer
        for key in obj_shipping:
            format_day_and_bool_dict(obj_shipping, key)

        result_list.append(obj_shipping)

    return result_list
