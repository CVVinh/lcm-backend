from sqlalchemy.sql import func
from chalicelib.models.models import Kitting, GroupMaster, AccountGroupMaster, Order, Arrival, Asset
from chalicelib.models import session
from chalicelib.utils.utils import check_operation_status, object_as_dict, add_update_object, check_is_main_is_set, get_list_asset_is_set
from chalicelib.gen_codes import GenCodeConstant
from chalicelib.messages import MessageResponse

gen_code_constant = GenCodeConstant()
message_kitting_constant = MessageResponse()
message_kitting_constant.setName("Kitting")


def add_t_kitting(kitting_obj):
    """
    add record for kitting.

    Arguments:
        kitting_obj: json body
    Returns:
        Response: Returning a message.
    """
    asset_id = kitting_obj.get("assetId")
    create_t_kitting = Kitting()
    # If asset status is disposed and asset operation in another table, not created record
    if check_status := check_operation_status(kitting_obj):
        return (False, check_status.body.get("msg"))
    # If kitting master exists in Order, add kitting master into Kitting
    query_order = session.query(Order).join(
        Arrival, Arrival.orderId == Order.orderId).join(
        Asset, Asset.arrivalId == Arrival.arrivalId).filter(Asset.assetId == asset_id).first()
    if query_order.kittingMasterId:
        create_t_kitting.kittingMasterId = query_order.kittingMasterId

    session.add(add_update_object(kitting_obj, create_t_kitting))
    session.commit()
    return (True, message_kitting_constant.MESSAGE_SUCCESS_CREATED)


def update_t_kitting_info(kitting_obj):
    """
    update 1 record for kitting by id.

    Arguments:
        kitting_obj: json body
    Returns:
        Response: Returning a message.
    """
    asset_id = kitting_obj.get("assetId")
    kitting_status = kitting_obj.get("kittingStatus")
    kitting_master_id = kitting_obj.get("kittingMasterId")
    update_to_t_kitting = session.query(Kitting).filter(
        Kitting.assetId == asset_id, Kitting.isDeleted == False).first()
    join_asset = update_to_t_kitting.asset
    # If asset is none exist, return a message
    if update_to_t_kitting is None:
        return (False, message_kitting_constant.MESSAGE_ERROR_NOT_EXIST)
    # If kitting status is completed, Don't be updated
    if update_to_t_kitting.kittingStatus == gen_code_constant.KITTING_STATUS_COMPLETED:
        return (False, message_kitting_constant.MESSAGE_ERROR_STATUS_COMPLETED_UPDATED)
    # Update record kitting
    add_update_object(kitting_obj, update_to_t_kitting)

    # If kitting status is medium, update asset status is kitting and kitting date is current date
    if kitting_status == gen_code_constant.KITTING_STATUS_KITTING:
        join_asset.assetStatus = gen_code_constant.ASSET_STATUS_KITTING
        join_asset.kittingMasterId = kitting_master_id
        update_to_t_kitting.kittingAt = func.now()
    # If kitting status is completed, update asset status is stock and completed date is current date
    elif kitting_status == gen_code_constant.KITTING_STATUS_COMPLETED:
        join_asset.assetStatus = gen_code_constant.ASSET_STATUS_STOCK
        join_asset.kittingMasterId = kitting_master_id
        update_to_t_kitting.completedAt = func.now()
    update_to_t_kitting.modifiedAt = func.now()
    session.commit()
    return (True, message_kitting_constant.MESSAGE_SUCCESS_UPDATED)


def delete_t_kitting(query_params):
    """
    Delete 1 record for kitting by id.

    Argument:
        query_params: param search
    Returns:
        Response: Returning a message.
    """
    asset_id = query_params.get("assetId")
    delete_to_t_kitting = session.query(Kitting).filter(
        Kitting.assetId == asset_id, Kitting.isDeleted == False).first()
    # If asset is none exist, return a message
    if delete_to_t_kitting is None:
        return (False, message_kitting_constant.MESSAGE_ERROR_NOT_EXIST)
    # If kitting status is completed, Don't be deleted
    if delete_to_t_kitting.kittingStatus == gen_code_constant.KITTING_STATUS_COMPLETED:
        return (False, message_kitting_constant.MESSAGE_ERROR_STATUS_COMPLETED_DELETED)

    delete_to_t_kitting.isDeleted = True
    delete_to_t_kitting.deletedAt = func.now()
    session.commit()
    return (True, message_kitting_constant.MESSAGE_SUCCESS_DELETED)


def get_t_kitting_info(query_params):
    """
    get 1 record for kitting by id.

    Arguments:
        query_params: param search
    Returns:
        Response: Returning a message and a object include: assetInfo, procurementInfo,
            kittingMasterInfo, kittingUserInfo, accountInfo, groupInfo, kittingInfo objects.
    """
    asset_id = query_params.get("assetId")
    kitting = session.query(Kitting).filter(
        Kitting.assetId == asset_id).first()
    # If asset is none exist, return a message
    if kitting is None:
        return (False, message_kitting_constant.MESSAGE_ERROR_NOT_EXIST)

    join_asset = kitting.asset
    join_order = kitting.asset.arrival.order
    join_procurement = join_order.procurement
    join_kitting_master = kitting.asset.kittingMaster
    join_account = kitting.accountMaster
    join_kitting_user = kitting.kittingUser
    query_group = session.query(GroupMaster).join(AccountGroupMaster).filter(
        AccountGroupMaster.groupId == GroupMaster.groupId, AccountGroupMaster.accountId == join_account.accountId).first()
    asset_info = object_as_dict(join_asset, True)
    asset_info.update(check_is_main_is_set(asset_id))
    asset_info["listAssets"] = get_list_asset_is_set(asset_id)
    asset_info["kittingMasterInfo"] = object_as_dict(join_kitting_master, True)
    tmp_kitting = {
        "assetInfo": asset_info,
        "procurementInfo": object_as_dict(join_procurement, True),
        "kittingUserInfo": object_as_dict(join_kitting_user, True),
        "accountInfo": object_as_dict(join_account, True),
        "groupInfo": object_as_dict(query_group, True),
        "kittingInfo": object_as_dict(kitting, True),
        "message": message_kitting_constant.MESSAGE_SUCCESS_GET_INFO,
        'status': 200
    }
    return (True, tmp_kitting)
