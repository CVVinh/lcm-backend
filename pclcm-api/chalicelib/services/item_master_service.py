from chalicelib.models import session
from chalicelib.models.models import ItemMaster, MakerMaster
from chalicelib.utils.status_response import success_response, error_response
import datetime
from chalicelib.utils.utils import object_as_dict, camel_case_object, camel_to_snake, paginate, export
from chalicelib.messages import MessageResponse

message_item_master_constant = MessageResponse()
message_item_master_constant.setName("Item Master")


def field_to_dict(data):
    fields = [
        "itemId",
        "itemName",
        "itemTitle",
        "itemDescription",
        "orderUnit",
        "orderUnitMax",
        "janCode",
        "makerId",
        "makerModel",
        "assetType",
        "expirationDateFrom",
        "expirationDateTo",
        "osId",
        "price",
        "tax",
    ]
    return {field: data[field] for field in fields if field in data}


def filter_param_get_item_list(query_params):
    query_set = session.query(ItemMaster).join(
        MakerMaster, MakerMaster.makerId == ItemMaster.makerId)

    if query_params:
        parameters = {
            "item": ["itemId", "janCode", "makerId", "assetType"],
        }
        for param in query_params:
            # * Filter item search params
            if param in parameters["item"]:
                query_set = query_set.filter(
                    getattr(ItemMaster, param) == query_params[param]
                )
        # * search for item name
        if "itemName" in query_params:
            query_set = query_set.filter(
                ItemMaster.itemName.like(f"%{query_params['itemName']}%")
            )
        if "makerModel" in query_params:
            query_set = query_set.filter(
                ItemMaster.makerModel.like(f"%{query_params['makerModel']}%")
            )

        # * filter by dates
        if "expirationDateFrom" in query_params:
            query_set = query_set.filter(
                ItemMaster.expirationDateFrom >= query_params["expirationDateFrom"]
            )
        if "expirationDateTo" in query_params:
            query_set = query_set.filter(
                ItemMaster.expirationDateTo <= query_params["expirationDateTo"]
            )
        # * filter item expiration date after today
        if query_params.get("exStatus") == "1":
            query_set = query_set.filter(
                ItemMaster.expirationDateTo >= datetime.datetime.now()
            )

        if query_params.get("deletedRecordDisplayMode") == "0":
            query_set = query_set.filter(ItemMaster.isDeleted == 0)

    # list_item_obj = query_set.all()

    return [
        {
            **object_as_dict(query),
            # "maker": session.query(MakerMaster).get(query.maker_id)
            "maker": object_as_dict(query.makerMaster)
        }
        for query in query_set
    ]


def get_item_list(query_params):
    filter_param_get_list = filter_param_get_item_list(query_params)
    # paginate by pageNum & pageSize
    paginated_lst = paginate(filter_param_get_list, query_params)

    return success_response(
        {
            "mstItem": paginated_lst,
            "itemTotal": len(filter_param_get_list),
            "msg": message_item_master_constant.MESSAGE_SUCCESS_GET_LIST,
            "status": 200,
        }
    )


def add_item(data):
    create_item = ItemMaster()

    if data["expirationDateTo"] <= data["expirationDateFrom"]:
        return error_response(
            {"msg": "Expiration date to must be greater than Expiration date from!"},
            400,
        )
    if "orderUnitMax" in data and (data["orderUnit"] > data["orderUnitMax"]):
        return error_response(
            {"msg": "Order unit must be smaller than Order unit max"}, 400
        )

    if "makerId" not in data:
        return error_response({"msg": "makerId required"}, 400)

    maker_object = (
        session.query(MakerMaster)
        .filter(MakerMaster.makerId == data["makerId"], MakerMaster.isDeleted == 0)
        .first()
    )
    if maker_object is None:
        return error_response({"msg": "Maker not found!"}, 404)

    for key, val in field_to_dict(data).items():
        setattr(create_item, key, val)

    # calculate tax if entered
    if data["price"] and data["tax"]:
        tax_inc_price = float(
            int(data["price"]) * (1 + int(data["tax"]) / 100))
    else:
        tax_inc_price = None
    create_item.taxIncPrice = tax_inc_price

    session.add(create_item)
    session.commit()
    return success_response({"msg": message_item_master_constant.MESSAGE_SUCCESS_CREATED, "status": 200})


def update_item(data):
    update_to_item = (
        session.query(ItemMaster)
        .filter(ItemMaster.itemId == data["itemId"], ItemMaster.isDeleted == 0)
        .first()
    )

    if update_to_item is None:
        return error_response({"msg": message_item_master_constant.MESSAGE_ERROR_NOT_EXIST}, 404)

    if data["expirationDateTo"] <= data["expirationDateFrom"]:
        return error_response(
            {"msg": "Expiration date to must be greater than Expiration date from!"},
            400,
        )

    if (
        "orderUnitMax" in data and (
            data.get("orderUnit") > data.get("orderUnitMax"))
    ) or (
        update_to_item.orderUnitMax
        and (data.get("orderUnit") > update_to_item.orderUnitMax)
    ):
        return error_response(
            {"msg": "Order unit must be smaller than Order unit max"}, 400
        )

    for key, val in field_to_dict(data).items():
        setattr(update_to_item, key, val)

    # calculate tax if entered
    if "price" in data:
        tax_inc_price = float(data["price"] * (1 + update_to_item.tax / 100))
    elif "tax" in data:
        tax_inc_price = float(update_to_item.price * (1 + data["tax"] / 100))
    elif data["price"] and data["tax"]:
        tax_inc_price = float(data["price"] * (1 + data["tax"] / 100))
    else:
        tax_inc_price = None
    update_to_item.taxIncPrice = tax_inc_price

    update_to_item.modifiedAt = datetime.datetime.now()
    session.commit()

    return success_response({"msg": message_item_master_constant.MESSAGE_SUCCESS_UPDATED, "status": 200})


def get_item_info(itemId: int):
    resp_item = session.query(ItemMaster).filter(
        ItemMaster.itemId == itemId).first()

    if resp_item is None:
        return error_response({"msg": message_item_master_constant.MESSAGE_ERROR_NOT_EXIST}, 404)

    result = camel_case_object(resp_item)
    result["makerName"] = camel_case_object(resp_item.makerMaster)["makerName"]

    return success_response(
        {"itemInfo": result,
            "msg": message_item_master_constant.MESSAGE_SUCCESS_GET_INFO, "status": 200}
    )


def delete_item(itemId: int):
    del_item = session.query(ItemMaster).filter(
        ItemMaster.itemId == itemId).first()

    if del_item is None:
        return error_response({"msg": message_item_master_constant.MESSAGE_ERROR_NOT_EXIST}, 404)
    elif del_item.isDeleted == 1:
        return error_response({"msg": "Item already deleted"}, 400)

    del_item.isDeleted = 1
    del_item.deletedAt = datetime.datetime.now()

    return success_response(
        {
            "deletedAt": str(del_item.deletedAt),
            "msg": message_item_master_constant.MESSAGE_SUCCESS_DELETED,
            "status": 200,
        }
    )


def export_item_list(query_params):
    return export(filter_param_get_item_list(query_params))
