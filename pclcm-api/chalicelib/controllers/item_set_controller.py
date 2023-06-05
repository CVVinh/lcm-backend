from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import item_set_service
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.validators import item_set_schema
from chalice import Response
import datetime
item_set_bp = Blueprint(__name__)


@item_set_bp.route('/func/add-item-set', methods=['POST'])
@errors_handle
@transaction()
def item_set_add_controller():
    request = item_set_bp.current_request.json_body
    item_set_schema.validate_item_set_post(request)
    success, result = item_set_service.create_item_set(request)
    if success:
        return success_response({"message": result, "stasus": 200})
    return error_response({"message": str(result), "stasus": 400}, 400)


@item_set_bp.route('/func/update-item-set-info', methods=['PUT'])
@errors_handle
@transaction()
def item_set_update_controller():
    request = item_set_bp.current_request.json_body
    item_set_schema.validate_item_set_post(request)
    success, result = item_set_service.update_item_set(request)
    if success:
        return success_response({"message": result, "stasus": 200})
    return error_response({"message": str(result), "stasus": 400}, 400)


@item_set_bp.route('/func/delete-item-set', methods=['DELETE'])
@errors_handle
@transaction()
def item_set_delete_controller():
    request = item_set_bp.current_request.json_body
    success, result = item_set_service.delete_item_set(request)
    if success:
        return success_response({"message": result, "stasus": 200})
    return error_response({"message": str(result), "stasus": 400}, 400)


@item_set_bp.route('/func/get-item-set-info', methods=['GET'])
@errors_handle
@transaction()
def get_item_set_info_controller():
    request = item_set_bp.current_request.query_params
    success, result = item_set_service.get_item_set_info(request)
    if success:
        return success_response(result)
    return error_response({"message": str(result), "stasus": 400}, 400)


@item_set_bp.route('/func/get-item-set-list', methods=['GET'])
@errors_handle
@transaction()
def get_item_set_list_controller():
    request = item_set_bp.current_request.query_params
    success, result = item_set_service.get_item_set_list(request)
    if success:
        return success_response(result)
    return error_response({'message': str(result), "stasus": 400}, 400)


@item_set_bp.route('/func/export-item-set-list-csv', methods=['GET'])
@errors_handle
@transaction()
def get_item_set_list_controller():
    request = item_set_bp.current_request.query_params
    success, result = item_set_service.export_item_set_list_csv(request)
    file_name = f"item_set_list_{str(datetime.datetime.now())}"
    if success:
        return Response(
            result,
            headers={
                "Content-disposition": f"attachment; filename={file_name}.csv"
            },
        )
    return error_response({"message": str(result), "stasus": 400}, 400)
