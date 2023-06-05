from sqlalchemy.sql import func
from chalicelib.models.models import Use, Asset
from chalicelib.models import session
from chalicelib.utils.utils import check_operation_status, object_as_dict, add_update_object, check_is_main_is_set
from chalicelib.gen_codes import GenCodeConstant
from chalicelib.messages import MessageResponse

gen_code_constant = GenCodeConstant()
message_use_constant = MessageResponse()
message_use_constant.setName("Use")


def add_using(using_obj):
    """
    add record for using.

    Arguments:
        using_obj: json body
    Returns:
        Response: Returning a message.
    """
    create_using = Use()
    using_from = using_obj.get("usingFrom") or None
    using_to = using_obj.get("usingTo") or None
    asset_id = using_obj.get("assetId")
    # If asset status is disposed and asset operation in another table, not created record
    if check_status := check_operation_status(using_obj):
        return (False, check_status.body.get("msg"))

    # Update using from and using to into Asset
    query_asset = session.query(Asset).filter(
        Asset.assetId == asset_id).first()
    query_asset.usingFrom = using_from
    query_asset.usingTo = using_to

    session.add(add_update_object(using_obj, create_using))
    session.commit()
    return (True, message_use_constant.MESSAGE_SUCCESS_CREATED)


def update_using_info(using_obj):
    """
    update 1 record for using by id.

    Arguments:
        using_obj: json body
    Returns:
        Response: Returning a message.
    """
    asset_id = using_obj.get("assetId")
    use_status = using_obj.get("useStatus")
    update_to_using = session.query(Use).filter(
        Use.assetId == asset_id, Use.isDeleted == False).first()
    join_asset = update_to_using.asset
    # If asset is none exist, return a message
    if update_to_using is None:
        return (False, message_use_constant.MESSAGE_ERROR_NOT_EXIST)
    # If using status is completed, Don't be updated
    if update_to_using.useStatus == gen_code_constant.USE_STATUS_COMPLETED:
        return (False, message_use_constant.MESSAGE_ERROR_STATUS_COMPLETED_UPDATED)
    # Update record using
    add_update_object(using_obj, update_to_using)

    # If using status is medium, update asset status is using
    if use_status == gen_code_constant.USE_STATUS_USING:
        join_asset.assetStatus = gen_code_constant.ASSET_STATUS_USING
        use_status.workingOn
    # If using status is completed, update asset status is pickingup
    elif use_status == gen_code_constant.USE_STATUS_COMPLETED:
        join_asset.assetStatus = gen_code_constant.ASSET_STATUS_PICKING_UP
    update_to_using.modifiedAt = func.now()
    session.commit()
    return (True, message_use_constant.MESSAGE_SUCCESS_UPDATED)


def delete_using(query_params):
    """
    Delete 1 record for using by id.

    Argument:
        query_params: param search
    Returns:
        Response: Returning a message.
    """
    asset_id = query_params.get("assetId")
    delete_to_using = session.query(Use).filter(
        Use.assetId == asset_id, Use.isDeleted == False).first()
    # If asset is none exist, return a message
    if delete_to_using is None:
        return (False, message_use_constant.MESSAGE_ERROR_NOT_EXIST)
    # If using status is completed, Don't be deleted
    if delete_to_using.useStatus == gen_code_constant.USE_STATUS_COMPLETED:
        return (False, message_use_constant.MESSAGE_ERROR_STATUS_COMPLETED_DELETED)

    delete_to_using.isDeleted = True
    delete_to_using.deletedAt = func.now()
    session.commit()
    return (True, message_use_constant.MESSAGE_SUCCESS_DELETED)


def get_using_info(query_params):
    """
    get 1 record for using by id.

    Arguments:
        query_params: param search
    Returns:
        Response: Returning a message and a object include: assetInfo, procurementInfo,
            accountInfo, groupInfo, baseInfo, useInfo objects.
    """
    asset_id = query_params.get("assetId")
    using = session.query(Use).filter(
        Use.assetId == asset_id).first()
    # If asset is none exist, return a message
    if using is None:
        return (False, message_use_constant.MESSAGE_ERROR_NOT_EXIST)

    join_asset = using.asset
    join_order = using.asset.arrival.order
    join_procurement = join_order.procurement
    join_group = using.groupMaster
    join_account = using.accountMaster
    join_base = using.baseMaster

    asset_info = object_as_dict(join_asset, True)
    asset_info.update(check_is_main_is_set(asset_id))
    tmp_using = {
        "assetInfo": asset_info,
        "procurementInfo": object_as_dict(join_procurement, True),
        "accountInfo": object_as_dict(join_account, True),
        "groupInfo": object_as_dict(join_group, True),
        "baseInfo": object_as_dict(join_base, True),
        "useInfo": object_as_dict(using, True),
        "message": message_use_constant.MESSAGE_SUCCESS_GET_INFO,
        "status": 200
    }
    return (True, tmp_using)
