from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import asset_service
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.validators import asset_schema
from chalice import Response
import datetime
asset_bp = Blueprint(__name__)


@asset_bp.route('/func/add-asset', methods=['POST'])
@errors_handle
@transaction()
def asset_add_controller():
    request = asset_bp.current_request.json_body
    asset_schema.validate_asset_post(request)
    success, result = asset_service.create_asset(request)
    if success:
        return success_response({"message": result, "stasus": 200})
    return error_response({"message": str(result), "stasus": 400}, 400)


@asset_bp.route('/func/delete-asset', methods=['DELETE'])
@errors_handle
@transaction()
def asset_delete_controller():
    request = asset_bp.current_request.json_body
    success, result = asset_service.delete_asset(request)
    if success:
        return success_response({"message": result, "stasus": 200})
    return error_response({"message": str(result), "stasus": 400}, 400)


@asset_bp.route('/func/get-asset-info', methods=['GET'])
@errors_handle
@transaction()
def get_asset_info_controller():
    request = asset_bp.current_request.query_params
    success, result = asset_service.get_asset_info(request)
    if success:
        return success_response(result)
    return error_response({"message": str(result), "stasus": 400}, 400)


@asset_bp.route('/func/get-asset-list', methods=['GET'])
@errors_handle
@transaction()
def get_asset_list_controller():
    request = asset_bp.current_request.query_params
    success, result = asset_service.get_asset_list(request)
    if success:
        return success_response(result)
    return error_response({"message": str(result), "stasus": 400}, 400)


@asset_bp.route('/func/export-asset-list-csv', methods=['GET'])
@errors_handle
@transaction()
def get_asset_list_export_controller():
    request = asset_bp.current_request.query_params
    success, result = asset_service.export_asset_list_csv(request)
    file_name = f"asset_list_{str(datetime.datetime.now())}"
    if success:
        return Response(
            result,
            headers={
                "Content-disposition": f"attachment; filename={file_name}.csv"
            },
        )
    return error_response({"message": str(result), "stasus": 400}, 400)
