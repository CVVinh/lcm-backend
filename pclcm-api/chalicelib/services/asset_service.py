from chalicelib.models import session
from chalicelib.models.models import (Asset, AssetSet, AssetSetAsset, Arrival, AccountMaster, AccountGroupMaster,
                                      GroupMaster, Kitting, Shipping, Repairing, Disposal, Use, PickUp, Order, Procurement, ItemMaster, ItemSet, ItemSetItem)
import datetime
from chalicelib.utils.utils import object_as_dict, export, paginate, get_list_asset_is_set, check_is_main_is_set, add_update_object
from chalicelib.services.shipping_service import create_shipping
from chalicelib.services.asset_depre_service import add_asset_depreciation
from chalicelib.gen_codes import GenCodeConstant
from chalicelib.messages import MessageResponse

gen_code_constant = GenCodeConstant()
message_asset_constant = MessageResponse()
message_asset_constant.setName("Asset")
message_arrival_constant = MessageResponse()
message_arrival_constant.setName("Arrival")


def create_asset_set_asset(item_id_set, item_id, asset_set, asset):
    """
    add record for asset set asset.

    Arguments:
        item_id_set: an integer
        item_id: an integer
        asset_set: an object
        asset: an object.
    """
    if (
        item_set_item := session.query(ItemSetItem)
        .filter(
            ItemSetItem.itemIdSet == item_id_set,
            ItemSetItem.itemId == item_id,
        )
        .first()
    ):
        asset_set_asset = AssetSetAsset()
        asset_set_asset.assetIdSet = asset_set.assetIdSet
        obj_item_set_item = object_as_dict(item_set_item)
        obj_item_set_item.pop("itemSetItemId")
        obj_item_set_item.pop("itemIdSet")
        obj_item_set_item.pop("itemId")
        for key, val in obj_item_set_item.items():
            setattr(asset_set_asset, key.replace(
                "item", "asset"), val)
        asset_set_asset.assetId = asset.assetId
        session.add(asset_set_asset)


def create_asset(asset_obj):
    """
    add record for asset.

    Arguments:
        asset_obj: json body
    Returns:
        Response: Returning a message.
    """
    # try:
    arrival_id = asset_obj.get("arrivalId")
    asset = Asset()
    if (
        get_arrival := session.query(Arrival)
        .filter(Arrival.arrivalId == arrival_id)
        .first()
    ):
        get_arrival_obj = object_as_dict(get_arrival)
        item_id = get_arrival_obj.get("itemId")
        order_id = get_arrival_obj.get("orderId")
        order_record = session.query(Order).filter(
            Order.orderId == order_id).first()
        order_record_obj = object_as_dict(order_record)
        # Query ItemMaster, add itemName, assetType of record Asset
        item_record = session.query(ItemMaster).filter(
            ItemMaster.itemId == item_id).first()
        asset.arrivalId, asset.kittingMasterId, asset.assetNameKana, asset.assetType, depreciation_rule_id = (
            get_arrival_obj.get("arrivalId"),
            order_record_obj.get("kittingMasterId"),
            item_record.itemName, item_record.assetType,
            order_record_obj.get("depreciationRuleId")
        )
        session.add(add_update_object(asset_obj, asset))

        asset_id_last = object_as_dict(session.query(Asset).order_by(
            Asset.assetId.desc()).first())["assetId"]

        # # If depreciation rule id exist in Order, Create DepreciationRule
        if depreciation_rule_id:
            add_asset_depreciation({"assetId": asset_id_last,
                                    "depreciationRuleId": depreciation_rule_id})
        # Create shipping after creating asset
        if order_record:
            estimated_shipping_date, account_shipping = (
                order_record.estimatedShippingDate, get_arrival_obj["accountId"])
            create_shipping({"assetId": asset_id_last,
                            "estimatedShippingDate": estimated_shipping_date,
                             "accountId": account_shipping})

        # Create asset set after creating asset
        if item_id_set_order := order_record_obj.get("itemIdSet"):
            item_set_record = session.query(ItemSet).filter(
                ItemSet.itemIdSet == item_id_set_order).first()
            obj_item_id_set = object_as_dict(item_set_record)
            item_id_set = obj_item_id_set.get("itemIdSet")
            asset_set = AssetSet()
            order_id_list = list(
                map(lambda x: x.orderId, session.query(AssetSet)))
            query_asset_set = session.query(AssetSet).filter(
                AssetSet.orderId == order_record.orderId).first()
            # If order id already exist, Do not Create asset set
            if order_record.orderId in order_id_list:
                asset_set.assetIdSet = query_asset_set.assetIdSet
            elif item_id_set:
                obj_item_id_set.pop("itemIdSet")
                obj_item_id_set.pop("createdAt")
                obj_item_id_set.pop("modifiedAt")
                for key, val in obj_item_id_set.items():
                    setattr(asset_set, key.replace(
                        "item", "asset"), val)
                asset_set.orderId = order_record.orderId
                session.add(asset_set)

            # Create asset set asset after creating asset set
            create_asset_set_asset(
                item_id_set, item_id, asset_set, asset)
        return (True, message_asset_constant.MESSAGE_SUCCESS_CREATED)
    return (False, message_arrival_constant.MESSAGE_ERROR_NOT_EXIST)
    # except Exception as e:
    #     return (False, str(e))


def delete_asset(query_params):
    """
    Delete 1 record for asset by id.

    Argument:
        query_params: param search
    Returns:
        Response: Returning a message.
    """
    try:
        asset_id = query_params.get("assetId")
        check_exsit = (
            session.query(Asset)
            .filter(Asset.assetId == asset_id, Asset.isDeleted == False)
            .first()
        )
        if check_exsit is not None:
            check_exsit.isDeleted = True
            check_exsit.deletedAt = datetime.datetime.now().strftime(
                "%Y-%m-%d %H:%M:%S"
            )
            session.add(check_exsit)
            session.commit()
            return (True, message_asset_constant.MESSAGE_SUCCESS_DELETED)

        return (False, "Record not found!")
    except Exception as e:
        return (False, str(e))


def get_asset_info(query_params):
    """
    get 1 record for asset by id.

    Arguments:
        query_params: param search
    Returns:
        Response: Returning a message and a object include asset, obj group, obj item and obj account.
    """
    try:
        asset_id = query_params.get("assetId")
        query_asset = session.query(Asset).filter(
            Asset.assetId == asset_id)
        if check_exist := query_asset.first():
            obj_asset = object_as_dict(check_exist, True)
            # item qua arrval id
            if arrival_record := (
                session.query(Arrival)
                .filter(Arrival.arrivalId == check_exist.arrivalId)
                .first()
            ):
                arrival_record_obj = object_as_dict(arrival_record, True)
                item_record = (
                    session.query(ItemMaster)
                    .filter(
                        ItemMaster.itemId == arrival_record.itemId,
                        ItemMaster.isDeleted == False,
                    )
                    .first()
                )
                obj_asset["item"] = object_as_dict(item_record, True)
                if order_id := arrival_record_obj.get("orderId"):
                    if order_record := (
                        session.query(Order).filter(
                            Order.orderId == order_id).first()
                    ):
                        order_record_obj = object_as_dict(order_record, True)
                        if procument_id := order_record_obj.get("procurementId"):
                            if procument_record := (
                                session.query(Procurement)
                                .filter(
                                    Procurement.procurementId
                                    == obj_asset.get("procurementId"),
                                    Procurement.isDeleted == False,
                                )
                                .first()
                            ):
                                obj_asset["procument"] = object_as_dict(
                                    procument_record, True)

            account_id = None
            if shipping_record := (
                session.query(Shipping)
                .filter(Shipping.assetId == asset_id, Shipping.isDeleted == False)
                .first()
            ):
                obj_asset["shippingReceptionStatus"] = shipping_record.shippingReceptionStatus
                obj_asset["shippingStatus"] = shipping_record.shippingStatus
                if (
                    shipping_record.shippingStatus == gen_code_constant.SHIPPING_STATUS_PRE_SHIPPING
                    or shipping_record.shippingStatus == gen_code_constant.SHIPPING_STATUS_SHIPPING
                ) and account_id is None:
                    account_id = shipping_record.accountId

            if pickup_record := (
                session.query(PickUp)
                .filter(PickUp.assetId == asset_id, PickUp.isDeleted == False)
                .first()
            ):
                obj_asset["pickupStatus"] = pickup_record.pickUpStatus
                if (
                    pickup_record.pickUpStatus == gen_code_constant.PICK_UP_STATUS_PRE_PICKING_UP
                    or pickup_record.pickUpStatus == gen_code_constant.PICK_UP_STATUS_PICKING_UP
                ) and account_id is None:
                    account_id = pickup_record.accountId

            if reparing_record := (
                session.query(Repairing)
                .filter(Repairing.assetId == asset_id, Repairing.isDeleted == False)
                .first()
            ):
                obj_asset["repairingStatus"] = reparing_record.repairingStatus
                if (
                    reparing_record.repairingStatus == gen_code_constant.REPAIRING_STATUS_PRE_REPAIRING
                    or reparing_record.repairingStatus == gen_code_constant.REPAIRING_STATUS_REPAIRING
                ):
                    obj_asset["reparing"] = object_as_dict(
                        reparing_record, True)

            if disposal_record := (
                session.query(Disposal)
                .filter(Disposal.assetId == asset_id, Disposal.isDeleted == False)
                .first()
            ):
                obj_asset["disposalStatus"] = disposal_record.disposalStatus
                if (
                    disposal_record.disposalStatus == gen_code_constant.DISPOSAL_STATUS_PRE_DISPOSING
                    or disposal_record.disposalStatus == gen_code_constant.DISPOSAL_STATUS_DISPOSING
                ) and account_id is None:
                    account_id = disposal_record.accountId

            if use_record := (
                session.query(Use)
                .filter(Use.assetId == asset_id, Use.isDeleted == False)
                .first()
            ):
                obj_asset["usingStatus"] = use_record.useStatus
                if (
                        use_record.useStatus == gen_code_constant.USE_STATUS_PRE_USING
                        or use_record.useStatus == gen_code_constant.USE_STATUS_USING
                ) and account_id is None:
                    account_id = use_record.accountId

            if kitting_record := (
                session.query(Kitting)
                .filter(Kitting.assetId == asset_id, Kitting.isDeleted == False)
                .first()
            ):
                obj_asset["kittingStatus"] = kitting_record.kittingStatus
                if (
                    kitting_record.kittingStatus == gen_code_constant.KITTING_STATUS_PRE_KITTING
                    or kitting_record.kittingStatus == gen_code_constant.KITTING_STATUS_KITTING
                ) and account_id is None:
                    account_id = kitting_record.accountId

            obj_asset["group"] = {}
            obj_asset["account"] = {}
            if check_exist.kittingMaster:
                obj_asset["kittingMaster"] = object_as_dict(
                    check_exist.kittingMaster, True)
            if check_exist.accountMaster:
                query_group = session.query(GroupMaster).join(AccountGroupMaster, AccountGroupMaster.groupId == GroupMaster.groupId).filter(
                    AccountGroupMaster.accountId == check_exist.accountMaster.accountId).first()
                obj_asset["group"] = object_as_dict(query_group, True)
                obj_asset["account"] = object_as_dict(
                    check_exist.accountMaster, True)
            # Check record is main or is set
            obj_asset.update(check_is_main_is_set(asset_id))
            obj_asset["listAssets"] = get_list_asset_is_set(asset_id)
            obj_asset["message"] = message_asset_constant.MESSAGE_SUCCESS_GET_INFO
            obj_asset["status"] = 200
            return (True, obj_asset)

        return (False, message_asset_constant.MESSAGE_ERROR_NOT_EXIST)
    except Exception as e:
        return (False, str(e))


def get_asset_list(query_params):
    """
    Get 1 or many record for asset by params.

    Argument:
        query_params: param search
    Returns:
        Response: Returning a message, total record, lists.
    """
    try:
        filter_param_get_list = filter_param_get_list_asset(query_params)
        # Paginate by pageNum & pageSize
        paginated_lst = paginate(filter_param_get_list, query_params)
        return (True, {
            "assetList": paginated_lst,
            "totalRecords": len(filter_param_get_list),
            "message": message_asset_constant.MESSAGE_SUCCESS_GET_LIST,
            "status": 200
        })
    except Exception as e:
        return (False, str(e))


def export_asset_list_csv(query_params):
    try:
        return export(filter_param_get_list_asset(query_params))

    except Exception as e:
        return (False, str(e))


def filter_param_get_list_asset(query_params):
    """
    Query and search asset with parameters

    Arguments:
        query_params: param search
    Returns:
        List: Returning a list object.
    """
    # Query Column needs to get, join tables containing information to get
    query_list_asset = session.query(Asset.assetId, Asset.assetStatus, Asset.assetNameKana, Asset.assetType, Asset.accountId,
                                     AccountMaster.accountName, GroupMaster.groupId, GroupMaster.groupName, Shipping.shippingStatus,
                                     Kitting.kittingStatus, Repairing.repairingStatus, Use.useStatus, Disposal.disposalStatus,
                                     PickUp.pickUpStatus, AssetSetAsset.assetIdSet,
                                     Procurement.procurementId).join(
        AccountMaster, AccountMaster.accountId == Asset.accountId, isouter=True).join(
        AccountGroupMaster, AccountGroupMaster.accountId == AccountMaster.accountId, isouter=True).join(
        GroupMaster, GroupMaster.groupId == AccountGroupMaster.groupId, isouter=True).join(
        Shipping, Shipping.assetId == Asset.assetId, isouter=True).join(
        Kitting, Kitting.assetId == Asset.assetId, isouter=True).join(
        Repairing, Repairing.assetId == Asset.assetId, isouter=True).join(
        Use, Use.assetId == Asset.assetId, isouter=True).join(
        Disposal, Disposal.assetId == Asset.assetId, isouter=True).join(
        PickUp, PickUp.assetId == Asset.assetId, isouter=True).join(
        AssetSetAsset, AssetSetAsset.assetId == Asset.assetId, isouter=True).join(
        Arrival, Arrival.arrivalId == Asset.arrivalId, isouter=True).join(
        Order, Order.orderId == Arrival.orderId, isouter=True).join(
        Procurement, Procurement.procurementId == Order.procurementId, isouter=True)
    # If any Param exists, then search. In contrast, search the record has not been deleted
    if query_params:
        params_search_asset = ["assetStatus", "assetId", "assetType"]
        # Search for params that exist in Asset
        for param in params_search_asset:
            if param in query_params:
                query_list_asset = query_list_asset.filter(
                    getattr(Asset, param) == query_params[param]
                )
        # Search Arrival with procurementId
        if "procurementId" in query_params:
            query_list_asset = query_list_asset.filter(
                Procurement.procurementId == query_params["procurementId"]
            )
        # Search Arrival with accountId
        if "accountId" in query_params:
            query_list_asset = query_list_asset.filter(
                AccountMaster.accountId == query_params["accountId"]
            )
        # Search Arrival with groupId
        if "groupId" in query_params:
            query_list_asset = query_list_asset.filter(
                GroupMaster.groupId == query_params["groupId"]
            )
        # If deleted record display mode is "0", search the record has not been deleted
        if query_params.get("deletedRecordDisplayMode") == "0":
            query_list_asset = query_list_asset.filter(Asset.isDeleted == 0)
    else:
        query_list_asset = query_list_asset.filter(Asset.isDeleted == 0)

    result_list = []
    for asset in query_list_asset.all():
        obj_asset = {**asset}
        obj_asset |= check_is_main_is_set(obj_asset.get("assetId"))
        result_list.append(obj_asset)
    return result_list
