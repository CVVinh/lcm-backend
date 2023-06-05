from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import procurement_service
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.validators import procurement_schema
from chalice import Response
import datetime
procurement_bp = Blueprint(__name__)


@procurement_bp.route('/func/add-procurement', methods=['POST'])
@errors_handle
@transaction()
def procurement_add_controller():
    request = procurement_bp.current_request.json_body
    procurement_schema.validate_procument_add(request)
    success, result = procurement_service.create_procurement(
        request)
    if success:
        return success_response(result)
    return error_response({"message": str(result), "stasus": 400}, 400)


@procurement_bp.route('/func/update-procurement-info', methods=['PUT'])
@errors_handle
@transaction()
def procurement_update_controller():
    request = procurement_bp.current_request.json_body
    procurement_schema.validate_procument_put(request)
    success, result = procurement_service.update_procurement(
        request)
    if success:
        return success_response(result)
    return error_response({"message": str(result), "stasus": 400}, 400)


@procurement_bp.route('/func/delete-procurement', methods=['DELETE'])
@errors_handle
@transaction()
def procurement_delete_controller():
    request = procurement_bp.current_request.json_body
    success, result = procurement_service.delete_procurement(request)
    if success:
        return success_response({"message": result, "stasus": 200})
    return error_response({"message": str(result), "stasus": 400}, 400)


@procurement_bp.route('/func/get-procurement-info', methods=['GET'])
@errors_handle
@transaction()
def get_procurement_info_controller():
    request = procurement_bp.current_request.query_params
    success, result = procurement_service.get_procurement_info(request)
    if success:
        return success_response(result)
    return error_response({"message": str(result), "stasus": 400}, 400)


@procurement_bp.route('/func/get-procurement-list', methods=['GET'])
@errors_handle
@transaction()
def get_procurement_list_controller():
    request = procurement_bp.current_request.query_params
    success, result = procurement_service.get_procurement_list(request)
    if success:
        return success_response(result)
    return error_response({"message": str(result), "stasus": 400}, 400)


@procurement_bp.route('/func/export-procurement-list-csv', methods=['GET'])
@errors_handle
@transaction()
def get_procurement_list_export_controller():
    request = procurement_bp.current_request.query_params
    success, result = procurement_service.export_procurement_list_csv(request)
    file_name = f"procurement_list_{str(datetime.datetime.now())}"
    if success:
        return Response(
            result,
            headers={
                "Content-disposition": f"attachment; filename={file_name}.csv"
            },
        )
    return error_response({"message": str(result), "stasus": 400}, 400)
