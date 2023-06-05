from sqlalchemy.sql import func
from chalicelib.models.models import (
    ItemMaster,
    Arrival,
    Order,
    Procurement,
    AccountMaster,
    ItemSetItem,
    AccountGroupMaster,
    GroupMaster,
    AssetSet
)
from chalicelib.models import session
from chalicelib.utils.status_response import success_response
from chalicelib.utils.utils import add_update_object, object_as_dict, paginate, export, format_day_and_bool_dict
from chalicelib.services.asset_service import create_asset
from chalicelib.gen_codes import GenCodeConstant
from chalicelib.messages import MessageResponse

gen_code_constant = GenCodeConstant()
message_arrival_constant = MessageResponse()
message_arrival_constant.setName("Arrival")
message_asset_constant = MessageResponse()
message_asset_constant.setName("Asset")
message_order_constant = MessageResponse()
message_order_constant.setName("Order")


def add_record_arrival_into_db(arrival_obj, item_id):
    """
    Create 1 record for arrival master and save into db.

    Arguments:
        arrival_obj: json body
        item_id: an integer
    Returns:
        The arrival id an object.
    """
    create_arrival = Arrival()
    field_inspection_status = arrival_obj.get("inspectionStatus")
    field_inspection_account_id = arrival_obj.get("inspectionAccountId")
    field_failure_action = arrival_obj.get("failureAction")
    # Assign item id of table ItemSet into table Arrival
    create_arrival.itemId = item_id

    # If Inspection status is passed transfer asset is registered
    if field_inspection_status == gen_code_constant.INSPECTION_STATUS_PASS:
        create_arrival.isAsset = True
    # If Inspection status is passed or failed, inspection person do exist
    if field_inspection_account_id and field_inspection_status in [gen_code_constant.INSPECTION_STATUS_PASS, gen_code_constant.INSPECTION_STATUS_UNQUALIFIED]:
        create_arrival.failureAction = field_failure_action
        create_arrival.inspectionAccountId = field_inspection_account_id
        # Assign asset approve person is inspection person
        create_arrival.assetApproveAccountId = field_inspection_account_id
        # Inspection date transfer current date
        create_arrival.inspectionDate = func.now()

    session.add(add_update_object(arrival_obj, create_arrival))

    # If mode add arrived, filter arrival last record
    arrivalRecord = object_as_dict(session.query(Arrival).order_by(
        Arrival.arrivalId.desc()).limit(1).first())
    # If asset is registered, call api create asset by arrival id
    if arrivalRecord["isAsset"]:
        field_using_from = arrival_obj.get("usingFrom") or None
        field_using_to = arrival_obj.get("usingTo") or None
        field_account_id = arrival_obj.get("accountId") or None
        create_asset({"arrivalId": arrivalRecord["arrivalId"],
                      "usingFrom": field_using_from,
                      "usingTo": field_using_to,
                      "accountId": field_account_id
                      })


def add_arrival(arrival_obj):
    """
    add record for arrival.

    Arguments:
        arrival_obj: json body
    Returns:
        Response: Returning a message.
    """
    field_item_id = arrival_obj.get("itemId")
    field_item_id_set = arrival_obj.get("itemIdSet")
    # Filter item_id_set in table ItemSetItem and create a list item_id in table ItemSetItem
    list_item_id = [query_item_set_item.itemId
                    for query_item_set_item in session.query(ItemSetItem.itemId)
                    .filter(field_item_id_set == ItemSetItem.itemIdSet)]

    quantities = 1
    if (
        query_order := session.query(Order)
        .filter(Order.orderId == arrival_obj.get("orderId"))
        .first()
    ):
        quantities = query_order.quantity
    else:
        return (True, message_order_constant.MESSAGE_ERROR_NOT_EXIST)
    # Adding record according to the item_id_set
    if field_item_id_set:
        for _ in range(quantities):
            for item_id in list_item_id:
                add_record_arrival_into_db(arrival_obj, item_id)
    # Adding record according to the item_id
    elif field_item_id:
        add_record_arrival_into_db(arrival_obj, field_item_id)

    session.commit()
    return (True, message_arrival_constant.MESSAGE_SUCCESS_CREATED)


def update_arrival_info(arrival_obj):
    """
    update 1 record for arrival by id.

    Arguments:
        arrival_obj: json body
    Returns:
        Response: Returning a message.
    """
    arrival_id = arrival_obj.get("arrivalId")
    update_to_arrival = (
        session.query(Arrival)
        .filter(
            Arrival.arrivalId == arrival_id,
            Arrival.isDeleted == False
        )
        .first()
    )
    field_using_from = arrival_obj.get("usingFrom") or None
    field_using_to = arrival_obj.get("usingTo") or None
    field_account_id = arrival_obj.get("accountId") or None
    field_inspection_status = arrival_obj.get("inspectionStatus")
    field_inspection_account_id = arrival_obj.get("inspectionAccountId")
    field_failure_action = arrival_obj.get("failureAction")
    # If arrival do not exist, return a message
    if update_to_arrival is None:
        return (False, message_arrival_constant.MESSAGE_ERROR_NOT_EXIST)
    # Update arrival
    add_update_object(arrival_obj, update_to_arrival)

    check_main_item = session.query(ItemSetItem).filter(
        ItemSetItem.itemId == update_to_arrival.itemId).first()
    check_order_exist = session.query(AssetSet).filter(
        AssetSet.orderId == update_to_arrival.orderId).first()
    # If Inspection status is passed transfer asset is registered
    if field_inspection_status == gen_code_constant.INSPECTION_STATUS_PASS:
        update_to_arrival.isAsset = True
        if check_main_item.isMain == True or check_order_exist:
            # If asset is registered, call api create asset by arrival id
            create_asset({"arrivalId": arrival_id,
                          "usingFrom": field_using_from,
                          "usingTo": field_using_to,
                          "accountId": field_account_id
                          })
        else:
            session.rollback()
            return (False, message_asset_constant.MESSAGE_ERROR_ITEM_IS_NOT_MAIN)
        # If exist order into arrival
        if update_to_arrival.order:
            # Procurement status transfer Ordered
            procurement_join = update_to_arrival.order.procurement
            procurement_join.procurementStatus = gen_code_constant.PROCUREMENT_STATUS_ARRIVED
            # Order date transfer current date
            order_join = update_to_arrival.order
            order_join.orderOn = func.now()

    # If Inspection status is passed or failed, inspection person do exist
    if field_inspection_account_id and field_inspection_status in [gen_code_constant.INSPECTION_STATUS_PASS, gen_code_constant.INSPECTION_STATUS_UNQUALIFIED]:
        update_to_arrival.failureAction = field_failure_action
        update_to_arrival.inspectionAccountId = field_inspection_account_id
        # Assign asset approve person is inspection person
        update_to_arrival.assetApproveAccountId = field_inspection_account_id
        # Inspection date transfer current date
        update_to_arrival.inspectionDate = func.now()

    # Update modified time
    update_to_arrival.modifiedAt = func.now()
    session.flush()
    session.commit()
    return (True, message_arrival_constant.MESSAGE_SUCCESS_UPDATED)


def get_arrival_info(query_params):
    """
    get 1 record for arrival by id.

    Arguments:
        query_params: param search
    Returns:
        Response: Returning a message and a object include: arrivalInfo, itemInfo, orderInfo and procurementInfo objects.
    """
    print("Asdasdasd", MessageResponse.MESSAGE_SUCCESS_GET_INFO)
    arrival_id = query_params.get("arrivalId")
    arrival = session.query(Arrival).filter(
        Arrival.arrivalId == arrival_id).first()
    # If Arrival do not exist, return a message
    if arrival is None:
        return (False, "Arrival does not exist!")

    # Join MakerMaster and take makerName
    makerName = object_as_dict(
        arrival.itemMaster.makerMaster, True)["makerName"]
    # Join ItemMaster
    itemInfo = object_as_dict(arrival.itemMaster, True)
    itemInfo["makerName"] = makerName

    accountInfo = object_as_dict(arrival.accountMaster, True)
    groupInfo = session.query(GroupMaster).join(AccountGroupMaster).filter(
        GroupMaster.groupId == AccountGroupMaster.groupId, AccountGroupMaster.accountId == arrival.accountMaster.accountId).first()
    # Set default orderInfo and procurementInfo is empty
    orderInfo = {}
    procurementInfo = {}
    # If order id in Arrival, orderInfo and procurementInfo
    if arrival.orderId is not None:
        orderInfo = object_as_dict(arrival.order, True)
        procurementInfo = object_as_dict(arrival.order.procurement, True)

    tmp_arrival_info = {
        "arrivalInfo": object_as_dict(arrival, True),
        "itemInfo": itemInfo,
        "oderInfo": orderInfo,
        "accountInfo": accountInfo,
        "groupInfo": object_as_dict(groupInfo, True),
        "procurementInfo": procurementInfo,
        "message": message_arrival_constant.MESSAGE_SUCCESS_GET_INFO,
        "stasus": 200,
    }
    return (True, tmp_arrival_info)


def delete_arrival_info(query_params):
    """
    Delete 1 record for arrival by id.

    Argument:
        query_params: param search
    Returns:
        Response: Returning a message.
    """
    arrival_id = query_params.get("arrivalId")
    # Query Arrival
    delete_to_arrival = (
        session.query(Arrival)
        .filter(
            Arrival.arrivalId == arrival_id,
            Arrival.isDeleted == False
        )
        .first()
    )
    # If Arrival do not exist, return a message
    if delete_to_arrival is None:
        return (False, "Arrival does not exist!")
    # If Arrival is being ordered, return a message
    if delete_to_arrival.arrivalType == gen_code_constant.ARRIVAL_TYPE_ORDER:
        return (False, "Do not delete because it is being ordered!")

    # Update flag and deleted time
    delete_to_arrival.isDeleted = True
    delete_to_arrival.deletedAt = func.now()
    return (True, message_arrival_constant.MESSAGE_SUCCESS_DELETED)


def get_arrival_list(query_params):
    """
    Get 1 or many record for arrival by params.

    Argument:
        query_params: param search
    Returns:
        Response: Returning a message, total record, lists.
    """
    filter_param_get_list = filter_param_get_list_arrival(query_params)
    # Paginate by pageNum & pageSize
    paginated_lst = paginate(filter_param_get_list, query_params)
    return success_response(
        {
            "arrivalList": paginated_lst,
            "itemTotal": len(filter_param_get_list),
            "msg": message_arrival_constant.MESSAGE_SUCCESS_GET_LIST,
            "status": 200,
        }
    )


def export_arrival_list(query_params):

    # * Print dict
    return export(filter_param_get_list_arrival(query_params))


def filter_param_get_list_arrival(query_params):
    """
    Query and search arrival with parameters

    Arguments:
        query_params: param search
    Returns:
        List: Returning a list object.
    """
    # Query Column needs to get arrival, join tables containing information to get
    query_list_arrival = session.query(Arrival.arrivalId, Arrival.arrivalType, Arrival.isAsset, Arrival.arrivalOn,
                                       Arrival.baseId, Arrival.itemId, Arrival.inspectionStatus, Arrival.failureAction,
                                       Arrival.accountId, ItemMaster.itemName, AccountMaster.accountName, GroupMaster.groupId,
                                       GroupMaster.groupName, Order.estimatedArrivalDate, Order.orderOn, ItemMaster.assetType,
                                       Arrival.inspectionDate, Procurement.procurementId).join(
        ItemMaster, ItemMaster.itemId == Arrival.itemId, isouter=True).join(
        Order, Order.orderId == Arrival.orderId, isouter=True).join(
        Procurement, Procurement.procurementId == Order.procurementId, isouter=True).join(
        AccountMaster, AccountMaster.accountId == Arrival.accountId, isouter=True).join(
        AccountGroupMaster, AccountGroupMaster.accountId == AccountMaster.accountId, isouter=True).join(
        GroupMaster, GroupMaster.groupId == AccountGroupMaster.groupId, isouter=True)
    # If any Param exists, then search. In contrast, search the record has not been deleted
    if query_params:
        params_search_arrival = ["arrivalId", "arrivalType", "isAsset", "baseId", "itemId", "inspectionStatus",
                                 "failureAction", "quotationRequester"]
        params_search_date_from = ["estimatedArrivalDateFrom", "orderOnFrom"]
        params_search_date_to = ["estimatedArrivalDateTo", "orderOnTo"]
        # Search for params that exist in Arrival
        for param in params_search_arrival:
            if param in query_params:
                query_list_arrival = query_list_arrival.filter(
                    getattr(Arrival, param) == query_params[param]
                )
        # Search Arrival with estimatedArrivalDateFrom and orderOnFrom
        for param_date_from in params_search_date_from:
            if param_date_from in query_params:
                replace_from = param_date_from.replace("From", "")
                query_list_arrival = query_list_arrival.filter(
                    getattr(
                        Order, replace_from) >= query_params[param_date_from]
                )
        # Search Arrival with estimatedArrivalDateTo and orderOnTo
        for param_date_to in params_search_date_to:
            if param_date_to in query_params:
                replace_to = param_date_to.replace("To", "")
                query_list_arrival = query_list_arrival.filter(
                    getattr(Order, replace_to) <= query_params[param_date_to]
                )
        # Search Arrival with procurementId
        if "procurementId" in query_params:
            query_list_arrival = query_list_arrival.filter(
                Procurement.procurementId == query_params["procurementId"]
            )
        # Search Arrival with itemName
        if "itemName" in query_params:
            query_list_arrival = query_list_arrival.filter(
                ItemMaster.itemName.like(f"%{query_params['itemName']}%")
            )
        # If deleted record display mode is "0", search the record has not been deleted
        if query_params.get("deletedRecordDisplayMode") == "0":
            query_list_arrival = query_list_arrival.filter(
                Arrival.isDeleted == 0)
    else:
        query_list_arrival = query_list_arrival.filter(Arrival.isDeleted == 0)

    result_list = []

    # Create loop of lists asset, assign it to an object and then assign to a new list.
    for arrival in query_list_arrival.all():
        obj_arrival = {**arrival}
        obj_order = {
            "estimatedArrivalDate": str(obj_arrival["estimatedArrivalDate"]),
            "orderOn": str(obj_arrival["orderOn"]),
        }
        obj_item = {
            "itemId": obj_arrival["itemId"],
            "itemName": obj_arrival["itemName"]
        }
        obj_arrival["item"] = obj_item
        obj_arrival["order"] = obj_order

        # format type datetime.datetime to string and bool to integer
        for key in obj_arrival:
            format_day_and_bool_dict(obj_arrival, key)

        result_list.append(obj_arrival)
    return result_list
