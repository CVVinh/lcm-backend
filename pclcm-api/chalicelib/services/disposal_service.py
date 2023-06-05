from chalicelib.models import session
from chalicelib.models.models import (
    Disposal,
    Asset,
    OutsourcingCompanyMaster,
    Procurement,
    Order,
    Arrival
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
message_disposal_constant = MessageResponse()
message_disposal_constant.setName("Disposal")


def add_disposal(data):
    # * Check if assetId already added for Disposal
    disposal_opr = session.query(Disposal).filter(
        Disposal.assetId == data["assetId"], Disposal.isDeleted == 0).first()

    if disposal_opr is not None:
        return error_response({"msg": "assetId already added"}, 400)

    if check_status := check_operation_status(data):
        return check_status

    session.add(Disposal(assetId=data.get(
        "assetId"), createdAt=datetime.now()))
    session.commit()

    return success_response({"msg": message_disposal_constant.MESSAGE_SUCCESS_CREATED})


def update_disposal(data):
    asset_lst = session.query(Asset).filter(
        Asset.assetId == data["assetId"], Asset.isDeleted == 0).first()

    outsourcing_company_lst = session.query(OutsourcingCompanyMaster).filter(
        OutsourcingCompanyMaster.outsourcingCompanyId == data["outsourcingCompanyId"], OutsourcingCompanyMaster.isDeleted == 0).first()

    disposal_lst = session.query(Disposal).filter(
        Disposal.assetId == data["assetId"], Disposal.isDeleted == 0).first()

    if asset_lst is None:
        return error_response({"msg": message_disposal_constant.MESSAGE_ERROR_NOT_EXIST}, 404)
    if outsourcing_company_lst is None:
        return error_response({"msg": "Outsourcing company not found!"}, 404)
    if disposal_lst is None:
        return error_response({"msg": "Disposal item not found"}, 404)

    disposal_lst.assetId = data["assetId"]
    disposal_lst.outsourcingCompanyId = data["outsourcingCompanyId"]
    disposal_lst.disposalStatus = data["disposalStatus"]

    if data.get("disposalStatus") == gen_code_constant.DISPOSAL_STATUS_DISPOSING:
        asset_lst.assetStatus = gen_code_constant.ASSET_STATUS_DISPOSING
    if data.get("disposalStatus") == gen_code_constant.DISPOSAL_STATUS_COMPLETED:
        asset_lst.assetStatus = gen_code_constant.ASSET_STATUS_DISPOSED
    disposal_lst.modifiedAt = datetime.now()

    session.commit()

    return success_response({"msg": message_disposal_constant.MESSAGE_SUCCESS_UPDATED})


def get_disposal_info(assetId: int):
    disposal_info = session.query(Disposal).filter_by(
        assetId=assetId, isDeleted=0).first()

    # * Check if Disposal object exists
    if disposal_info is None:
        return error_response({"msg": message_disposal_constant.MESSAGE_ERROR_NOT_EXIST}, 404)

    # * get objects from Asset, Procurement, OutsourceCompany
    result = {"disposalInfo": object_as_dict(disposal_info, True)}

    asset_lst = session.query(Asset).filter_by(
        assetId=disposal_info.assetId, isDeleted=0).first()
    result["assetInfo"] = object_as_dict(asset_lst, True)

    procurement_lst = session.query(Procurement).join(Order).join(
        Arrival).filter_by(arrivalId=asset_lst.arrivalId, isDeleted=0).first()
    result["procurementInfo"] = object_as_dict(procurement_lst, True)

    outsource_lst = session.query(OutsourcingCompanyMaster).filter_by(
        outsourcingCompanyId=disposal_info.outsourcingCompanyId, isDeleted=0).first()
    result["outsourceCompanyInfo"] = object_as_dict(outsource_lst, True)

    return success_response(
        {
            **check_is_main_is_set(assetId),
            **result,
            "msg": message_disposal_constant.MESSAGE_SUCCESS_GET_INFO,
        }
    )


def delete_disposal(assetId: int):
    del_disposal = session.query(Disposal).filter(
        Disposal.assetId == assetId).first()

    if del_disposal is None or del_disposal.isDeleted != 0:
        return error_response({"msg": message_disposal_constant.MESSAGE_ERROR_NOT_EXIST}, 404)

    del_disposal.isDeleted = 1
    del_disposal.deletedAt = datetime.now()
    return success_response(
        {"deletedAt": str(del_disposal.deletedAt),
         "msg": message_disposal_constant.MESSAGE_SUCCESS_DELETED}
    )
