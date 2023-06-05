from chalice.app import Blueprint, Request
from chalice import Response

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import item_master_service
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.validators import item_master_schema
from datetime import datetime

item_info_bp = Blueprint(__name__)


@item_info_bp.route('/func/get-item-list/', methods=['GET'])
@errors_handle
@transaction()
def item_list_controller():
    query_params = item_info_bp.current_request.query_params
    try:
        return item_master_service.get_item_list(query_params)
    except Exception as e:
        return error_response({"message": str(e)}, 400)


@item_info_bp.route('/func/add-item/', methods=['POST'])
@errors_handle
@transaction()
def add_item_controller():
    request: Request = item_info_bp.current_request
    item_master_schema.validate_item_post(request.json_body)
    try:
        return item_master_service.add_item(request.json_body)
    except Exception as e:
        return error_response({"message": str(e)}, 400)


@item_info_bp.route('/func/update-item-info/', methods=['PUT'])
@errors_handle
@transaction()
def update_item_controller():
    request: Request = item_info_bp.current_request
    item_master_schema.validate_item_post(request.json_body)
    try:
        return item_master_service.update_item(request.json_body)
    except Exception as e:
        return error_response({'msg': str(e)}, 400)


@item_info_bp.route('/func/get-item-info/', methods=['GET'])
@errors_handle
@transaction()
def get_item_info_controller():
    request: Request = item_info_bp.current_request
    try:
        itemId: int = request.query_params.get("itemId", "")
        return item_master_service.get_item_info(itemId)
    except Exception as e:
        return error_response({"msg": str(e)}, 400)


@item_info_bp.route('/func/delete-item/', methods=['DELETE'])
@errors_handle
@transaction()
def delete_item_controller():
    request: Request = item_info_bp.current_request
    try:
        itemId: int = request.query_params.get("itemId", "")
        return item_master_service.delete_item(itemId)
    except Exception as e:
        return error_response({"msg": str(e)}, 400)


@item_info_bp.route('/func/export-item-list/', methods=['GET'])
@errors_handle
@transaction()
def export_item_controller():
    query_params = item_info_bp.current_request.query_params
    try:
        success, result = item_master_service.export_item_list(query_params)
        file_name = f"item_list{str(datetime.now())}"
        if success:
            return Response(
                result,
                headers={
                    "Content-disposition": f"attachment;filename={file_name}.csv"
                },
            )
    except Exception as e:
        return error_response({"message": str(e)}, 400)
