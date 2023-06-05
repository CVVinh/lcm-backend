from chalicelib.models import session
from chalicelib.models.models import PickUp, AccountGroupMaster, GroupMaster
from sqlalchemy.sql import func
from chalicelib.utils.utils import check_operation_status, object_as_dict, add_update_object, check_is_main_is_set, get_list_asset_is_set
from chalicelib.gen_codes import GenCodeConstant
from chalicelib.messages import MessageResponse

gen_code_constant = GenCodeConstant()
message_pick_up_constant = MessageResponse()
message_pick_up_constant.setName("Pick Up")


def create_pickup(pickup_obj):
    """
    add record for pick up.

    Arguments:
        pickup_obj: json body
    Returns:
        Response: Returning a message.
    """
    shipping = PickUp()
    # If asset status is disposed and asset operation in another table, not created record
    if check_status := check_operation_status(pickup_obj):
        return (False, check_status.body.get("msg"))

    session.add(add_update_object(pickup_obj, shipping))
    session.commit()
    return (True, message_pick_up_constant.MESSAGE_SUCCESS_CREATED)


def update_pickup(pickup_obj):
    """
    update 1 record for pick up by id.

    Arguments:
        pickup_obj: json body
    Returns:
        Response: Returning a message.
    """
    asset_id = pickup_obj.get("assetId")
    pick_up_status = pickup_obj.get("pickUpStatus")
    pick_up_type = pickup_obj.get("pickUpType")
    check_exsit = session.query(PickUp).filter(
        PickUp.assetId == asset_id, PickUp.isDeleted == False).first()
    join_asset = check_exsit.asset
    # If pick up is none exist, return a message
    if check_exsit is None:
        return (False, message_pick_up_constant.MESSAGE_ERROR_NOT_EXIST)
    add_update_object(pickup_obj, check_exsit)

    # If pick up status is shipping, update asset status is shipping
    if pick_up_status == gen_code_constant.PICK_UP_STATUS_PICKING_UP:
        join_asset.assetStatus = gen_code_constant.ASSET_STATUS_PICKING_UP
        check_exsit.pickUpScheduledDate = func.now()
    # If pick up status is completed, update asset status is using
    elif pick_up_status == gen_code_constant.PICK_UP_STATUS_COMPLETED:
        if pick_up_type == gen_code_constant.PICK_UP_TYPE_FOR_STOCKING:
            join_asset.assetStatus = gen_code_constant.ASSET_STATUS_STOCK
        elif pick_up_type == gen_code_constant.PICK_UP_TYPE_FOR_REPAIRING:
            join_asset.assetStatus = gen_code_constant.ASSET_STATUS_REPAIRING
        check_exsit.completedOn = func.now()

    check_exsit.modifiedAt = func.now()
    session.commit()
    return (True, message_pick_up_constant.MESSAGE_SUCCESS_UPDATED)


def delete_pickup(query_params):
    """
    Delete 1 record for pick up by id.

    Argument:
        query_params: param search
    Returns:
        Response: Returning a message.
    """
    asset_id = query_params.get("assetId")
    check_exsit = session.query(PickUp).filter(
        PickUp.assetId == asset_id, PickUp.isDeleted == False).first()
    if check_exsit is None:
        return (False, message_pick_up_constant.MESSAGE_ERROR_NOT_EXIST)
    # If pick up status is completed, Don't be deleted
    if check_exsit.pickUpStatus == gen_code_constant.PICK_UP_STATUS_COMPLETED:
        return (False, message_pick_up_constant.MESSAGE_ERROR_STATUS_COMPLETED_DELETED)

    check_exsit.isDeleted = True
    check_exsit.deletedAt = func.now()
    session.commit()
    return (True, message_pick_up_constant.MESSAGE_SUCCESS_DELETED)


def get_pickup_info(query_params):
    """
    get 1 record for pick up by id.

    Arguments:
        query_params: param search
    Returns:
        Response: Returning a message and a object include: assetInfo, procurementInfo, accountInfo,
            groupInfo, outsourcingCompanyInfo and pickUpInfo objects.
    """
    asset_id = query_params.get("assetId")
    check_exsit = session.query(PickUp).filter(
        PickUp.assetId == asset_id).first()
    # If asset is none exist, return a message
    if check_exsit is None:
        return (False, message_pick_up_constant.MESSAGE_ERROR_NOT_EXIST)

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
    tmp_pick_up = {
        "assetInfo": asset_info,
        "procurementInfo": object_as_dict(join_procurement, True),
        "accountInfo": object_as_dict(join_account, True),
        "groupInfo": object_as_dict(query_group, True),
        "outsourcingCompanyInfo": object_as_dict(join_outsourcing_ompany, True),
        "pickUpInfo": object_as_dict(check_exsit, True),
        "message": message_pick_up_constant.MESSAGE_SUCCESS_GET_INFO,
        "status": 200
    }
    return (True, tmp_pick_up)
