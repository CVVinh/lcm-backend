from chalicelib.models import session
from chalicelib.models.models import ItemMaster, Procurement, Order, AccountMaster, GroupMaster, AccountGroupMaster, Arrival, Asset, Disposal, MakerMaster
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.utils.utils import object_as_dict, paginate, export, format_day_and_bool_dict
from chalicelib.gen_codes import GenCodeConstant
from chalicelib.messages import MessageResponse

gen_code_constant = GenCodeConstant()
message_lcm_constant = MessageResponse()
message_lcm_constant.setName("Life Cycle Management")


def lcm_query_set():
    return session.query(
        Arrival.arrivalId,
        Arrival.arrivalOn,
        Asset.assetId,
        Asset.assetStatus,
        Asset.assetType,
        Asset.assetFrom,
        Asset.assetTo,
        Asset.assetNameKana,
        Disposal.disposalStatus,
        Disposal.modifiedAt,
        AccountMaster.accountId,
        AccountMaster.accountName,
        GroupMaster.groupId,
        ItemMaster.itemId,
        ItemMaster.itemName,
        ItemMaster.serialNumber,
        ItemMaster.janCode,
        ItemMaster.osId,
        ItemMaster.assetType,
        MakerMaster.makerName,
        Procurement.procurementId,
        Procurement.procurementName,
        Procurement.quotationRequester,
        Order.orderOn
    ).join(
        Asset,
        Asset.arrivalId == Arrival.arrivalId,
        isouter=True
    ).join(
        AccountMaster,
        AccountMaster.accountId == Arrival.accountId,
        isouter=True
    ).join(
        AccountGroupMaster,
        AccountGroupMaster.accountId == AccountMaster.accountId,
        isouter=True
    ).join(
        GroupMaster,
        GroupMaster.groupId == AccountGroupMaster.groupId,
        isouter=True
    ).join(
        Disposal,
        Disposal.assetId == Asset.assetId,
        isouter=True
    ).join(
        ItemMaster,
        ItemMaster.itemId == Arrival.itemId,
        isouter=True
    ).join(
        MakerMaster,
        MakerMaster.makerId == ItemMaster.makerId,
        isouter=True
    ).join(
        Order,
        Order.orderId == Arrival.orderId,
        isouter=True
    ).join(
        Procurement,
        Procurement.procurementId == Order.procurementId,
        isouter=True
    )


def filter_params_asset_item_procurement(query_set, query_params):
    parameters = {
        "asset": [
            "assetId", "assetStatus", "assetType"],
        "item": [
            "itemId", "serialNumber", "janCode", "osId", "assetType"],
        "procurement": [
            "procurementId", "quotationRequester"],
    }

    for param in query_params:
        if param in parameters["asset"]:
            query_set = query_set.filter(
                getattr(Asset, param) == query_params[param])
        if param in parameters["item"]:
            query_set = query_set.filter(
                getattr(ItemMaster, param) == query_params[param])
        if param in parameters["procurement"]:
            query_set = query_set.filter(
                getattr(Procurement, param) == query_params[param])

    return query_set


def filter_id_account_group(query_set, query_params):
    if "accountId" in query_params:
        query_set = query_set.filter(
            AccountMaster.accountId == query_params["accountId"])
    if "groupId" in query_params:
        query_set = query_set.filter(
            GroupMaster.groupId == query_params["groupId"])

    return query_set


def filter_date_range_asset_arrival_order(query_set, query_params):
    # * Filter assetFrom & assetTo
    if "assetFrom" in query_params:
        query_set = query_set.filter(
            Asset.assetFrom >= query_params["assetFrom"])
    if "assetTo" in query_params:
        query_set = query_set.filter(
            Asset.assetTo <= query_params["assetTo"])

    # * Filter disposalOnFrom & disposalOnTo
    disposal_on_from = query_params.get("disposalOnFrom")
    disposal_on_to = query_params.get("disposalOnTo")
    if disposal_on_from or disposal_on_to:
        query_set = query_set.filter(
            Disposal.disposalStatus == GenCodeConstant.DISPOSAL_STATUS_COMPLETED)
    if disposal_on_from:
        query_set = query_set.filter(
            Disposal.modifiedAt >= query_params["disposalOnFrom"])
    if disposal_on_to:
        query_set = query_set.filter(
            Disposal.modifiedAt <= query_params["disposalOnTo"])

    # * Filter Arrival & Order
    if "arrivalOnFrom" in query_params:
        query_set = query_set.filter(
            Arrival.arrivalOn >= query_params["arrivalOnFrom"])
    if "arrivalOnTo" in query_params:
        query_set = query_set.filter(
            Arrival.arrivalOn <= query_params["arrivalOnTo"])
    if "orderOnFrom" in query_params:
        query_set = query_set.filter(
            Order.orderOn >= query_params["orderOnFrom"])
    if "orderOnTo" in query_params:
        query_set = query_set.filter(
            Order.orderOn <= query_params["orderOnTo"])

    return query_set


def filter_name_item_maker_procurement(query_set, query_params):
    if "itemName" in query_params:
        query_set = query_set.filter(
            ItemMaster.itemName.like(f"%{query_params['itemName']}%"))
    if "makerName" in query_params:
        query_set = query_set.filter(
            MakerMaster.makerName.like(f"%{query_params['makerName']}%"))
    if "procurementName" in query_params:
        query_set = query_set.filter(
            Procurement.procurementName.like(f"%{query_params['procurementName']}%"))

    return query_set


def get_list_lcm(query_params):
    query_set = lcm_query_set()
    if query_params:
        query_set = filter_params_asset_item_procurement(
            query_set, query_params)
        query_set = filter_id_account_group(
            query_set, query_params)
        query_set = filter_date_range_asset_arrival_order(
            query_set, query_params)
        query_set = filter_name_item_maker_procurement(
            query_set, query_params)

    result_dict = []
    for query in query_set:
        asset_obj = {**query}

        if asset_obj.get("disposalStatus") == gen_code_constant.DISPOSAL_STATUS_COMPLETED:
            asset_obj["disposalOn"] = asset_obj.get("disposalOn")

        for key in asset_obj:
            format_day_and_bool_dict(asset_obj, key)
        result_dict.append(asset_obj)

    paginated_lst = paginate(result_dict, query_params)

    return success_response({
        "arrivalList": paginated_lst,
        "arrivalTotal": len(result_dict),
        "msg": message_lcm_constant.MESSAGE_SUCCESS_GET_LIST,
        "status": 200
    })


def export_list_lcm(query_params):
    query_set = lcm_query_set()
    if query_params:
        query_set = filter_params_asset_item_procurement(
            query_set, query_params)
        query_set = filter_id_account_group(
            query_set, query_params)
        query_set = filter_date_range_asset_arrival_order(
            query_set, query_params)
        query_set = filter_name_item_maker_procurement(
            query_set, query_params)

    result_dict = []
    for query in query_set:
        asset_obj = {**query}

        if asset_obj.get("disposalStatus") == gen_code_constant.DISPOSAL_STATUS_COMPLETED:
            asset_obj["disposalOn"] = asset_obj.get("modifiedAt")

        for key in asset_obj:
            format_day_and_bool_dict(asset_obj, key)
        result_dict.append(asset_obj)

    return export(result_dict)
