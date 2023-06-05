from chalicelib.models import session
from chalicelib.models.models import AssetDepreciation, Asset, DepreciationRule, Arrival, Order, Procurement, ItemMaster, AccountMaster, AccountGroupMaster, GroupMaster
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.utils.utils import object_as_dict, paginate, export, format_day_and_bool_dict
from datetime import datetime

from chalicelib.gen_codes import GenCodeConstant
from chalicelib.messages import MessageResponse

gen_code_constant = GenCodeConstant()
message_asset_depre_constant = MessageResponse()
message_asset_depre_constant.setName("Asset Depreciation")


def field_to_dict(data):
    fields = {
        "assetDepreciationId",
        "assetId",
        "depreciationRuleId",
    }
    return {field: data[field] for field in fields if field in data}


def validate_data(data):
    if "assetId" not in data:
        return error_response({"msg": "assetId required!"}, 400)
    if "depreciationRuleId" not in data:
        return error_response({"msg": "depreciationRuleId required!"}, 400)

    depre_rule_obj = session.query(DepreciationRule).filter_by(
        depreciationRuleId=data["depreciationRuleId"]).first()
    if depre_rule_obj is None:
        return error_response({"msg": "Depreciation rule not found"}, 404)


def add_asset_depreciation(data):
    create_asset_depre = AssetDepreciation()

    if validate := validate_data(data):
        return validate

    asset_exist = session.query(AssetDepreciation).filter_by(
        assetId=data["assetId"]).first()
    if asset_exist is not None:
        return error_response({"msg": "assetId already existed!"}, 400)

    for key, val in field_to_dict(data).items():
        setattr(create_asset_depre, key, val)
    create_asset_depre.createdAt = datetime.now()
    session.add(create_asset_depre)
    session.commit()
    return success_response({"msg": "Success", "status": 200})


def update_asset_depreciation(data):
    update_asset_depre = session.query(AssetDepreciation).filter_by(
        assetId=data["assetId"], isDeleted=0).first()

    if update_asset_depre is None:
        return error_response({"msg": "Asset does not exist!"}, 404)

    if validate := validate_data(data):
        return validate

    for key, val in field_to_dict(data).items():
        setattr(update_asset_depre, key, val)

    update_asset_depre.modifiedAt = datetime.now()
    session.commit()

    return success_response({"msg": "Asset depreciation updated successfully!", "status": 200})


def get_asset_depreciation_info(assetId: int):
    asset_depre_info = session.query(AssetDepreciation).filter_by(
        assetId=assetId).first()

    if asset_depre_info is None:
        return error_response({"msg": "Asset does not exist!"}, 404)

    result = object_as_dict(asset_depre_info)

    return success_response({
        "assetDepreciationInfo": result,
        "msg": "Successfully get assetDepreciationInfo",
        "status": 200
    })


def asset_depre_query_set():
    return session.query(
        AssetDepreciation.assetDepreciationId,
        Asset.assetId,
        Asset.assetStatus,
        Asset.assetType,
        Asset.assetFrom,
        Asset.assetTo,
        DepreciationRule.depreciationRuleId,
        DepreciationRule.depreciationRuleName,
        DepreciationRule.fiscalYear,
        DepreciationRule.baseYear,
        DepreciationRule.amountPerYear,
        ItemMaster.itemId,
        ItemMaster.itemName,
        ItemMaster.serialNumber,
        ItemMaster.janCode,
        ItemMaster.osId,
        ItemMaster.makerModel,
        ItemMaster.taxIncPrice,
        Procurement.procurementId,
        AccountMaster.accountName,
        GroupMaster.groupId
    ).join(
        Asset,
        Asset.assetId == AssetDepreciation.assetId,
        isouter=True
    ).join(
        DepreciationRule,
        DepreciationRule.depreciationRuleId == AssetDepreciation.depreciationRuleId,
        isouter=True
    ).join(
        AccountMaster,
        AccountMaster.accountId == Asset.accountId,
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
        Arrival,
        Arrival.arrivalId == Asset.arrivalId,
        isouter=True
    ).join(
        ItemMaster,
        ItemMaster.itemId == Arrival.itemId,
        isouter=True
    ).join(
        Order,
        Order.itemId == ItemMaster.itemId,
        isouter=True
    ).join(
        Procurement,
        Procurement.procurementId == Order.procurementId,
        isouter=True
    )


def filter_params_asset_item_group_procurement(query_set, query_params):
    parameters = {
        "asset": ["assetId", "assetStatus", "assetType"],
        "item": ["itemId", "serialNumber", "janCode", "osId", "makerModel"],
        "procurement": ["procurementId"],
        "group": ["groupId"]
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
        if param in parameters["group"]:
            query_set = query_set.filter(
                getattr(GroupMaster, param) == query_params[param])

    return query_set


def filter_date_range_asset(query_set, query_params):
    # * Filter assetFrom & assetTo
    if "assetFrom" in query_params:
        query_set = query_set.filter(
            Asset.assetFrom >= query_params["assetFrom"])
    if "assetTo" in query_params:
        query_set = query_set.filter(
            Asset.assetTo <= query_params["assetTo"])

    return query_set


def filter_name_item_procurement(query_set, query_params):
    if "itemName" in query_params:
        query_set = query_set.filter(
            ItemMaster.itemName.like(f"%{query_params['itemName']}%"))
    if "procurementName" in query_params:
        query_set = query_set.filter(
            Procurement.procurementName.like(f"%{query_params['procurementName']}%"))
    if "accountName" in query_params:
        query_set = query_set.filter(
            AccountMaster.accountName.like(f"%{query_params['accountName']}%"))

    return query_set


def get_asset_depreciation_list(query_params):
    query_set = asset_depre_query_set()
    if query_params:
        query_set = filter_params_asset_item_group_procurement(
            query_set, query_params)
        query_set = filter_date_range_asset(query_set, query_params)
        query_set = filter_name_item_procurement(query_set, query_params)

    result_dict = []
    for query in query_set:
        asset_obj = {**query}

        for key in asset_obj:
            format_day_and_bool_dict(asset_obj, key)
        result_dict.append(asset_obj)

    paginated_lst = paginate(result_dict, query_params)

    return success_response({
        "assetList": paginated_lst,
        "assetTotal": len(result_dict),
        "msg": message_asset_depre_constant.MESSAGE_SUCCESS_GET_LIST,
        "status": 200
    })


def export_asset_depreciation_list(query_params):
    query_set = asset_depre_query_set()
    if query_params:
        query_set = filter_params_asset_item_group_procurement(
            query_set, query_params)
        query_set = filter_date_range_asset(query_set, query_params)
        query_set = filter_name_item_procurement(query_set, query_params)

    result_dict = []
    for query in query_set:
        asset_obj = {**query}

        for key in asset_obj:
            format_day_and_bool_dict(asset_obj, key)
        result_dict.append(asset_obj)

    return export(result_dict)
