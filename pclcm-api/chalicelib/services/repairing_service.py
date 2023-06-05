from chalicelib.models import session
from chalicelib.models.models import (
    Repairing,
    Asset,
    AccountMaster,
    OutsourcingCompanyMaster,
    Procurement,
    Order,
    Arrival,
    GroupMaster,
    AccountGroupMaster
)
from datetime import datetime
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.utils.utils import (
    check_operation_status,
    check_is_main_is_set,
    object_as_dict
)
from chalicelib.messages import MessageResponse
from chalicelib.gen_codes import GenCodeConstant

gen_code_constant = GenCodeConstant()
message_repairing_constant = MessageResponse()
message_repairing_constant.setName("Repairing")


def add_repairing(data):
    account_lst = session.query(AccountMaster).filter(
        AccountMaster.accountId == data["accountId"], AccountMaster.isDeleted == 0).first()

    # * Check if account exists
    if account_lst is None:
        return error_response({"msg": "Account not found!"}, 404)

    # * Check if assetId is already added for Repairing
    repair_opr = session.query(Repairing).filter(
        Repairing.assetId == data["assetId"], Repairing.isDeleted == 0).first()

    if repair_opr is not None:
        return error_response({"msg": "assetId already added!"}, 400)

    if check_status := check_operation_status(data):
        return check_status

    session.add(
        Repairing(
            assetId=data.get("assetId"),
            accountId=data.get("accountId"),
            createdAt=datetime.now(),
        )
    )
    session.commit()

    return success_response({"msg": message_repairing_constant.MESSAGE_SUCCESS_CREATED})


def update_repairing(data):
    asset_lst = session.query(Asset).filter(
        Asset.assetId == data["assetId"], Asset.isDeleted == 0).first()

    outsourcing_company_lst = session.query(OutsourcingCompanyMaster).filter(
        OutsourcingCompanyMaster.outsourcingCompanyId
        == data["outsourcingCompanyId"],
        OutsourcingCompanyMaster.isDeleted == 0,
    ).first()

    repairing_lst = session.query(Repairing).filter(
        Repairing.assetId == data["assetId"], Repairing.isDeleted == 0).first()

    # * Check if Asset,OutsourceCompany,Repairing objects exist in DB
    if asset_lst is None:
        return error_response({"msg": "Asset not found!"}, 404)
    if outsourcing_company_lst is None:
        return error_response({"msg": "Outsourcing company not found!"}, 404)
    if repairing_lst is None:
        return error_response({"msg": message_repairing_constant.MESSAGE_ERROR_NOT_EXIST}, 404)

    repairing_lst.assetId = data["assetId"]
    repairing_lst.outsourcingCompanyId = data["outsourcingCompanyId"]
    repairing_lst.repairingStatus = data["repairingStatus"]

    # * Change assetStatus on update
    if data.get("repairingStatus") == gen_code_constant.REPAIRING_STATUS_REPAIRING:
        asset_lst.assetStatus = gen_code_constant.ASSET_STATUS_REPAIRING
    if data.get("repairingStatus") == gen_code_constant.REPAIRING_STATUS_COMPLETED:
        asset_lst.assetStatus = gen_code_constant.ASSET_STATUS_STOCK
    repairing_lst.modifiedAt = datetime.now()

    session.commit()

    return success_response({"msg": message_repairing_constant.MESSAGE_SUCCESS_UPDATED})


def get_repairing_info(assetId: int):
    repairing_info = session.query(Repairing).filter_by(
        assetId=assetId, isDeleted=0).first()

    # * Check if Repairing object exists
    if repairing_info is None:
        return error_response({"msg": message_repairing_constant.MESSAGE_ERROR_NOT_EXIST}, 404)

    # * get objects from Asset,Procurement,Account,OutsourceCompany
    result = {"repairingInfo": object_as_dict(repairing_info, True)}

    asset_lst = session.query(Asset).filter_by(
        assetId=repairing_info.assetId).first()
    result["assetInfo"] = object_as_dict(asset_lst, True)

    procurement_lst = session.query(Procurement).join(Order).join(
        Arrival).filter(Arrival.arrivalId == asset_lst.arrivalId).first()
    result["procurementInfo"] = object_as_dict(procurement_lst, True)

    if repairing_info.accountId is not None:
        account_lst = session.query(AccountMaster).filter_by(
            accountId=repairing_info.accountId).first()
        result["accountInfo"] = object_as_dict(account_lst, True)

        group_lst = session.query(GroupMaster).join(AccountGroupMaster).filter_by(
            isDeleted=0, accountId=repairing_info.accountId).first()
        result["groupInfo"] = object_as_dict(group_lst, True)

    outsource_lst = session.query(OutsourcingCompanyMaster).filter_by(
        outsourcingCompanyId=repairing_info.outsourcingCompanyId, isDeleted=0).first()
    result["outsourceCompanyInfo"] = object_as_dict(outsource_lst, True)

    return success_response(
        {
            **check_is_main_is_set(assetId),
            **result,
            "msg": message_repairing_constant.MESSAGE_SUCCESS_GET_INFO,
        }
    )


def delete_repairing(assetId: int):
    del_repairing = (
        session.query(Repairing).filter(Repairing.assetId == assetId).first()
    )

    if del_repairing is None or del_repairing.isDeleted != 0:
        return error_response({"msg": message_repairing_constant.MESSAGE_ERROR_NOT_EXIST}, 404)

    del_repairing.isDeleted = 1
    del_repairing.deletedAt = datetime.now()
    return success_response(
        {
            "deletedAt": str(del_repairing.deletedAt),
            "msg": message_repairing_constant.MESSAGE_SUCCESS_DELETED,
        }
    )
