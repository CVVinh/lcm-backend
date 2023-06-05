from chalicelib.models import session
from chalicelib.models.models import Procurement, Order, ItemMaster, ItemSet, Arrival, AccountMaster
from sqlalchemy.sql import func
from chalicelib.utils.utils import object_as_dict, add_update_object, paginate, export, format_day_and_bool_dict
from chalicelib.messages import MessageResponse

message_procurement_constant = MessageResponse()
message_procurement_constant.setName("Procurement")


def create_procurement(procurement_object):
    """
    add record for procurement.

    Arguments:
        procurement_object: json body
    Returns:
        Response: Returning a message.
    """
    try:
        procure_management = procurement_object.get("procurementManagement")
        procure_detail_list = procurement_object.get("procurementDetailList")

        procurement = Procurement()
        # Add procument
        session.add(add_update_object(procure_management, procurement))
        session.commit()

        # Add order
        total_amount = 0
        for item in procure_detail_list:
            quantity = item.get("quantity")
            price_include_tax = item.get("item").get("taxIncPrice")

            order = Order()
            order.procurementId = procurement.procurementId
            order.quantity = quantity
            order.amount = order.quantity * price_include_tax
            total_amount += order.amount
            session.add(add_update_object(item.get("item"), order))
            session.commit()
        # update total amount
        procurement.totalAmount = total_amount

        return (True, {
            "procurementDetailList": object_as_dict(procure_detail_list),
            "procurementManagement": object_as_dict(procurement),
            "message": message_procurement_constant.MESSAGE_SUCCESS_CREATED,
            "status": 200
        })
    except Exception as e:
        return (False, str(e))


def update_procurement(procurement_object):
    """
    update 1 record for procurement by id.

    Arguments:
        procurement_object: json body
    Returns:
        Response: Returning a message.
    """
    try:
        procure_management = procurement_object.get("procurementManagement")
        procure_detail_list = procurement_object.get("procurementDetailList")

        # procument
        procurement_id = procure_management.get("procurementId")
        check_exist_procurement = session.query(Procurement).filter(
            Procurement.procurementId == procurement_id, Procurement.isDeleted == False).first()
        if check_exist_procurement:
            total_amount = 0
            if procure_detail_list and len(procure_detail_list) > 0:
                # delete all orders of procurement
                records = session.query(Order).filter(
                    Order.procurementId == procurement_id).all()
                for item in records:
                    session.delete(item)
                    session.commit()
                # add new, calc total amount
                for procurement in procure_detail_list:
                    quantity = procurement.get("quantity")
                    price_include_tax = procurement.get(
                        "item").get("taxIncPrice")

                    order = Order()
                    order.procurementId = procurement_id
                    order.quantity = quantity
                    order.amount = order.quantity * price_include_tax
                    total_amount += order.amount
                    session.add(add_update_object(procurement, order))
                    session.add(add_update_object(
                        procurement.get("item"), order))

            check_exist_procurement.isBack = procure_management.get(
                "isBack") if procure_management.get("isBack") is not None else False
            check_exist_procurement.procurementStatus = procure_management.get(
                "procurementStatus") if procure_management.get("procurementStatus") is not None else 0
            check_exist_procurement.total_amount = total_amount
            add_update_object(procurement_object, check_exist_procurement)

            session.commit()
            return (True, {
                "procurementDetailList": object_as_dict(procure_detail_list),
                "procurementManagement": object_as_dict(check_exist_procurement),
                "message": message_procurement_constant.MESSAGE_SUCCESS_UPDATED,
                "status": 200
            })
        return (False, message_procurement_constant.MESSAGE_ERROR_NOT_EXIST)
    except Exception as e:
        return (False, str(e))


def delete_procurement(procurement_object):
    """
    Delete 1 record for procurement by id.

    Argument:
        procurement_object: json body
    Returns:
        Response: Returning a message.
    """
    try:
        procurement_id = procurement_object.get("procurementId")
        if (
            check_exist_procurement := session.query(Procurement)
            .filter(
                Procurement.procurementId == procurement_id,
                Procurement.isDeleted == False,
            )
            .first()
        ):
            check_exist_procurement.isDeleted = True
            check_exist_procurement.deletedAt = func.now()
            session.commit()
            return (True, message_procurement_constant.MESSAGE_SUCCESS_DELETED)

        return (False, message_procurement_constant.MESSAGE_ERROR_NOT_EXIST)

    except Exception as e:
        return (False, str(e))


def get_procurement_info(query_params):
    """
    get 1 record for procurement by id.

    Arguments:
        query_params: param search
    Returns:
        Response: Returning a message, procurementDetailList, procurementManagement.
    """
    try:
        procurement_id = query_params.get("procurementId")
        obj_management = {}
        if (
            query_set := session.query(Procurement)
            .filter(
                Procurement.procurementId == procurement_id,
                Procurement.isDeleted == False,
            )
            .first()
        ):
            obj_management = object_as_dict(query_set, True)

            # get item list
            query_set_item = session.query(Order).filter(
                Order.procurementId == obj_management.get("procurementId")).all()
            list_item_details = []
            if len(query_set_item) > 0:
                for item in query_set_item:
                    obj_item_list = object_as_dict(item, True)
                    obj_item = {}

                    item_set = session.query(ItemSet).filter(
                        ItemSet.itemIdSet == obj_item_list.get("itemIdSet")).first()
                    item_check = session.query(ItemMaster).filter(
                        ItemMaster.itemId == item.itemId).first()
                    if item_set:
                        obj_item = object_as_dict(item_set, True)

                    if item_check:
                        obj_item = object_as_dict(item_check, True)

                    obj_item_list["item"] = obj_item

                    list_item_details.append(obj_item_list)

            return (True, {
                "procurementDetailList": list_item_details,
                "procurementManagement": obj_management,
                "msg": message_procurement_constant.MESSAGE_SUCCESS_GET_INFO,
                "status": 200
            })

        return (False, message_procurement_constant.MESSAGE_ERROR_NOT_EXIST)
    except Exception as e:
        return (False, str(e))


def get_procurement_list(query_params):
    """
    Get 1 or many record for procurement by params.

    Argument:
        query_params: param search
    Returns:
        Response: Returning a message, total record, lists.
    """
    try:
        filter_param_get_list = filter_param_get_list_procurement(query_params)
        paginated_lst = paginate(filter_param_get_list, query_params)
        return (True, {
            "procurementList": paginated_lst,
            "totalRecords": len(filter_param_get_list),
            "msg": message_procurement_constant.MESSAGE_SUCCESS_GET_LIST
        })

    except Exception as e:
        return (False, str(e))


def export_procurement_list_csv(query_params):
    try:
        return export(filter_param_get_list_procurement(query_params))
    except Exception as e:
        return (False, str(e))


def filter_param_get_list_procurement(query_params):
    """
    Query and search procurement with parameters

    Arguments:
        query_params: param search
    Returns:
        List: Returning a list object.
    """
    # Query Column needs to get procurement, join tables containing information to get
    query_list_procurement = session.query(Procurement.procurementId, Procurement.procurementName, Procurement.isBack,
                                           Procurement.procurementStatus, Procurement.totalAmount, Procurement.quotationRequester,
                                           Procurement.quotationAccountId, AccountMaster.accountName).join(
        AccountMaster, AccountMaster.accountId == Procurement.quotationAccountId, isouter=True)
    if query_params:
        params_search_procurement = [
            "procurementId", "procurementStatus", "isBack", "quotationRequester"]
        # Search for params that exist in Procurement
        for param in params_search_procurement:
            if param in query_params:
                query_list_procurement = query_list_procurement.filter(
                    getattr(Procurement, param) == query_params[param]
                )
        # Search Procurement with procurementName
        if "procurementName" in query_params:
            query_list_procurement = query_list_procurement.filter(
                Procurement.procurementName.like(
                    f"%{query_params['procurementName']}%")
            )
        # If deleted record display mode is "0", search the record has not been deleted
        if query_params.get("deletedRecordDisplayMode") == "0":
            query_list_procurement = query_list_procurement.filter(
                Procurement.isDeleted == 0)
    else:
        query_list_procurement = query_list_procurement.filter(
            Procurement.isDeleted == 0)

    result_list = []
   # Create loop of lists procurement, assign it to an object and then assign to a new list.
    for procurement in query_list_procurement.all():
        obj_procurement = {**procurement}

        # format type datetime.datetime to string and bool to integer
        for key in obj_procurement:
            format_day_and_bool_dict(obj_procurement, key)

        result_list.append(obj_procurement)
    return result_list
