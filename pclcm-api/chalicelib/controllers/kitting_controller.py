from chalice.app import Blueprint, Request
from chalice import Response

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import kitting_service
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.validators import kitting_schema
from datetime import datetime

kitting_bp = Blueprint(__name__)


@kitting_bp.route('/master/get-kitting-list', methods=['GET'])
@errors_handle
@transaction()
def kitting_list_controller():
    request = kitting_bp.current_request.query_params
    success, result = kitting_service.get_kitting_list(request)
    if success:
        return success_response(result)
    return error_response({'message': str(result), 'status': 400}, 400)


@kitting_bp.route('/master/add-kitting', methods=['POST'])
@errors_handle
@transaction()
def add_kitting_controller():
    request = kitting_bp.current_request.json_body
    kitting_schema.validate_kitting_list(request)
    success, result = kitting_service.add_kitting(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@kitting_bp.route('/master/update-kitting-info', methods=['PUT'])
@errors_handle
@transaction()
def update_kitting_controller():
    request = kitting_bp.current_request.json_body
    kitting_schema.validate_kitting_list(request)
    success, result = kitting_service.update_kitting(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@kitting_bp.route('/master/get-kitting-info', methods=['GET'])
@errors_handle
@transaction()
def get_kitting_info_controller():
    request = kitting_bp.current_request.query_params
    success, result = kitting_service.get_kitting_master_info(request)
    if success:
        return success_response(result)
    return error_response({'message': str(result), 'status': 400}, 400)


@kitting_bp.route('/master/delete-kitting', methods=['DELETE'])
@errors_handle
@transaction()
def delete_kitting_controller():
    request = kitting_bp.current_request.query_params
    success, result = kitting_service.delete_kitting(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@kitting_bp.route('/master/export-kitting-list', methods=['GET'])
@errors_handle
@transaction()
def export_kitting_controller():
    query_params = kitting_bp.current_request.query_params
    success, result = kitting_service.export_kitting_list(query_params)
    file_name = f"kitting_list{str(datetime.now())}"
    if success:
        return Response(
            result,
            headers={
                "Content-disposition": f"attachment; filename={file_name}.csv"
            },
        )
    return error_response({'message': str(result), 'status': 400}, 400)
