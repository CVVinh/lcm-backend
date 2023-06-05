import datetime
from sqlalchemy import and_, or_, join
from chalicelib.models import session
from chalicelib.models.models import ItemSet, ItemMaster, ItemSetItem
from sqlalchemy.sql import func
from chalicelib.utils.utils import object_as_dict, add_update_object, paginate, format_day_and_bool_dict, export
from chalicelib.messages import MessageResponse

message_item_set_constant = MessageResponse()
message_item_set_constant.setName("Item Set")


def response_message(message="Have an error in server", status=200):
    return {'msg': message, 'status': status}


def add_item_set_item(item_id_set, main_item_id, list_item):
    for item_id in list_item:
        model_item_set_item = ItemSetItem()
        model_item_set_item.itemIdSet = item_id_set
        model_item_set_item.itemId = item_id
        model_item_set_item.isMain = item_id == main_item_id
        session.add(model_item_set_item)
        session.commit()


def create_item_set(item_set_object):
    model_item_set = ItemSet()
    list_item = item_set_object.get("itemList")
    total_tax_inc_price = 0
    for item_id in list_item:
        check_item = session.query(ItemMaster).filter(
            ItemMaster.itemId == item_id).first()
        tax_inc_price = object_as_dict(check_item).get("taxIncPrice")
        if check_item or tax_inc_price:
            total_tax_inc_price += float(tax_inc_price)
    model_item_set.taxIncPrice = total_tax_inc_price
    session.add(add_update_object(item_set_object, model_item_set))
    session.commit()

    item_id_set = model_item_set.itemIdSet
    main_item_info = item_set_object.get("mainItemInfo")
    main_item_id = main_item_info.get("mainItemId")
    add_item_set_item(item_id_set, main_item_id, list_item)
    return (True, message_item_set_constant.MESSAGE_SUCCESS_CREATED)


def update_item_set(item_set_object):
    item_id_set = item_set_object.get("itemIdSet")
    list_item = item_set_object.get("itemList")
    item_set_exist = session.query(ItemSet).filter(
        ItemSet.itemIdSet == item_id_set, ItemSet.isDeleted == False).first()
    total_tax_inc_price = 0
    for item_id in list_item:
        check_item = session.query(ItemMaster).filter(
            ItemMaster.itemId == item_id).first()
        tax_inc_price = object_as_dict(check_item).get("taxIncPrice")
        if check_item or tax_inc_price:
            total_tax_inc_price += float(tax_inc_price)

    item_set_exist.taxIncPrice = total_tax_inc_price
    add_update_object(item_set_object, item_set_exist)

    check_exist_item_set = session.query(ItemSetItem).filter(
        ItemSetItem.itemIdSet == item_id_set).all()
    for item in check_exist_item_set:
        session.delete(item)
        session.commit()

    main_item_info = item_set_object.get("mainItemInfo")
    main_item_id = main_item_info.get("mainItemId")
    item_list_id = item_set_object.get("itemList")
    add_item_set_item(item_id_set, main_item_id, item_list_id)
    return (True, message_item_set_constant.MESSAGE_SUCCESS_UPDATED)


def delete_item_set(query_params):
    item_set_id = query_params.get("itemIdSet")
    item_set_exist = session.query(ItemSet).filter(
        ItemSet.itemIdSet == item_set_id, ItemSet.isDeleted == False).first()

    if item_set_exist is not None:
        item_set_exist.isDeleted = True
        item_set_exist.deletedAt = func.now()
        session.commit()
        return (True, message_item_set_constant.MESSAGE_SUCCESS_DELETED)

    return (False, message_item_set_constant.MESSAGE_ERROR_NOT_EXIST)


def get_item_set_info(query_params):
    item_set_id = query_params.get("itemIdSet")
    item_set_exist = session.query(ItemSet).filter(
        ItemSet.itemIdSet == item_set_id).first()

    # If Arrival do not exist, return a message
    if item_set_exist is None:
        return (False, message_item_set_constant.MESSAGE_ERROR_NOT_EXIST)

    query_item = session.query(ItemMaster.itemId, ItemMaster.assetType, ItemMaster.itemName,
                               ItemMaster.makerId, ItemMaster.makerModel, ItemMaster.janCode,
                               ItemMaster.osId, ItemMaster.expirationDateFrom, ItemMaster.expirationDateTo).join(
        ItemSetItem, ItemSetItem.itemId == ItemMaster.itemId, isouter=True).filter(
        ItemSetItem.itemIdSet == item_set_id)

    filter_main_item = query_item.filter(ItemSetItem.isMain == True).all()
    list_field_main_items = ["mainItemId", "mainAssetType", "mainItemName", "mainItemMaker",
                             "mainItemMakerModel", "mainItemJanCode", "mainItemOs"]
    for main_item in filter_main_item:
        main_item_obj = {
            field: main_item[index] for index, field in enumerate(list_field_main_items)
        }

    list_item = []
    list_field_items = ["itemId", "itemType", "itemName", "itemMaker", "itemMakerModel",
                        "itemJanCode", "itemOs", "itemExpirationDateFrom", "itemExpirationDateTo"]
    filter_list_items = query_item.all()
    for item in filter_list_items:
        item_obj = {field: item[index]
                    for index, field in enumerate(list_field_items)}
        list_item.append(item_obj)
        for key in item_obj:
            format_day_and_bool_dict(item_obj, key)

    return (True, {**object_as_dict(item_set_exist, True),
                   "mainItemInfo": main_item_obj,
                   "itemList": list_item,
                   "msg": message_item_set_constant.MESSAGE_SUCCESS_GET_INFO,
                   "status": 200
                   })


def get_item_set_list(query_params):
    """
    Get 1 or many record for item set by params.

    Argument:
        query_params: param search
    Returns:
        Response: Returning a message, total record, a list.
    """
    filter_param_get_list = filter_param_get_list_item_set(query_params)
    # Paginate by pageNum & pageSize
    paginated_lst = paginate(filter_param_get_list, query_params)
    return (True, {
        "mstItemSet": paginated_lst,
        "totalRecords": len(filter_param_get_list),
        "msg": message_item_set_constant.MESSAGE_SUCCESS_GET_LIST,
        "status": 200
    })


def export_item_set_list_csv(query_params):
    return export(filter_param_get_list_item_set(query_params))


def filter_param_get_list_item_set(query_params):
    """
    Query and search item set with parameters

    Arguments:
        query_params: param search
    Returns:
        List: Returning a list object.
    """
    # Query Column needs to get, join tables containing information to get
    query_list_item_set = session.query(ItemSet.itemIdSet, ItemSet.itemSetType, ItemSet.itemSetName, ItemMaster.itemId,
                                        ItemMaster.assetType, ItemMaster.itemName, ItemSet.itemSetExpirationDateFrom,
                                        ItemSet.itemSetExpirationDateTo, ItemSet.itemSetMakerId,
                                        ItemSet.taxIncPrice, ItemSetItem.isMain).join(
        ItemSetItem, ItemSetItem.itemIdSet == ItemSet.itemIdSet).join(
        ItemMaster, ItemMaster.itemId == ItemSetItem.itemId).filter(ItemSetItem.isMain == True)
    time_now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    # If any Param exists, then search. In contrast, search the record has not been deleted
    if query_params:
        expiration_status = query_params.get("expirationStatus")
        item_set_expiration_date_from = query_params.get(
            "itemSetExpirationDateFrom")
        item_set_expiration_date_to = query_params.get(
            "itemSetExpirationDateTo")
        param_item_set = ["itemIdSet", "itemSetType", "itemSetMakerId",
                          "itemSetMakerModel", "itemSetOs"]
        param_main_item = ["mainItemId", "mainAssetType",
                           "mainItemMakerId", "mainItemOsId"]
        # Search for params that exist in ItemSet
        for param in query_params:
            if param in param_item_set:
                query_list_item_set = query_list_item_set.filter(
                    getattr(ItemSet, param) == query_params[param]
                )
        # Search ItemSet with itemSetName
        if "itemSetName" in query_params:
            query_list_item_set = query_list_item_set.filter(
                ItemSet.itemSetName.like(f"%{query_params['itemSetName']}%"))
        # Search ItemSet with itemSetexpirationDateFrom
        if "itemSetexpirationDateFrom" in query_params and "itemSetExpirationDateTo" in query_params:
            query_list_item_set = query_list_item_set.filter(
                ItemSet.itemSetExpirationDateFrom >= item_set_expiration_date_from, ItemSet.itemSetExpirationDateTo <= item_set_expiration_date_to)
        # Search ItemSet with expiration status
        if expiration_status == 1:
            query_list_item_set = query_list_item_set.filter(
                ItemSet.itemSetExpirationDateTo >= time_now)
        # Search ItemSet with param main item
        for param in param_main_item:
            replace_param_name = param.replace("main", "")
            if "mainItemMakerId" in param or "mainItemOsId" in param:
                replace_param_name = param.replace("mainItem", "")
            change_field = replace_param_name[0].lower(
            ) + replace_param_name[1:]
            if param in query_params:
                query_list_item_set = query_list_item_set.filter(
                    getattr(ItemMaster, change_field) == query_params[param]
                )
        # Search ItemSet with mainItemJanCode
        if "mainItemJanCode" in query_params:
            query_list_item_set = query_list_item_set.filter(
                ItemMaster.janCode.like(f"%{query_params['mainItemJanCode']}%")
            )
        # Search ItemSet with mainItemMakerModel
        if "mainItemMakerModel" in query_params:
            query_list_item_set = query_list_item_set.filter(
                ItemMaster.makerModel.like(
                    f"%{query_params['mainItemMakerModel']}%")
            )
        # If deleted record display mode is "0", search the record has not been deleted
        if query_params.get("deletedRecordDisplayMode") == "0":
            query_list_item_set = query_list_item_set.filter(
                ItemSet.isDeleted == 0)
    else:
        query_list_item_set = query_list_item_set.filter(
            ItemSet.isDeleted == 0)

    result_list = []
    # Create loop of lists item set, assign it to an object and then assign to a new list.
    for item_set in query_list_item_set.all():
        obj_item_set = {**item_set}
        obj_item_set["mainItemId"] = obj_item_set.pop("itemId")
        obj_item_set["mainAssetType"] = obj_item_set.pop("assetType")
        obj_item_set["mainItemName"] = obj_item_set.pop("itemName")
        obj_main_item = {
            "mainItemId": obj_item_set["mainItemId"],
            "mainAssetType": obj_item_set["mainAssetType"],
            "mainItemName": obj_item_set["mainItemName"]
        }
        obj_item_set["mainItemInfo"] = obj_main_item
        # format type datetime.datetime to string and bool to integer
        for key in obj_item_set:
            format_day_and_bool_dict(obj_item_set, key)

        result_list.append(obj_item_set)

    return result_list
