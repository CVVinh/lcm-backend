from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import maker_service
from chalicelib.utils.status_response import error_response, success_response
from chalicelib.validators import maker_schema
from sqlalchemy.sql import func
from chalice import Response

maker_bp = Blueprint(__name__)


@maker_bp.route('/func/get-maker-list', methods=['GET'])
@errors_handle
@transaction()
def get_maker_list_controller():
    request = maker_bp.current_request.query_params
    success, result = maker_service.get_maker_list(request)
    if success:
        return success_response(result)
    return error_response({'message': str(result), 'status': 400}, 400)


@maker_bp.route('/func/add-maker', methods=['POST'])
@errors_handle
@transaction()
def add_maker_controller():
    request = maker_bp.current_request.json_body
    maker_schema.validate_post_maker_list(request)
    success, result = maker_service.add_maker(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@maker_bp.route('/func/update-maker-info', methods=['PUT'])
@errors_handle
@transaction()
def update_maker_info_controller():
    request = maker_bp.current_request.json_body
    maker_schema.validate_put_maker_list(request)
    success, result = maker_service.update_maker_info(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@maker_bp.route('/func/get-maker-info', methods=['GET'])
@errors_handle
@transaction()
def get_maker_info_controller():
    request = maker_bp.current_request.query_params
    success, result = maker_service.get_maker_info(request)
    if success:
        return success_response(result)
    return error_response({'message': str(result)}, 400)


@maker_bp.route('/func/delete-maker', methods=['DELETE'])
@errors_handle
@transaction()
def delete_maker_controller():
    request = maker_bp.current_request.query_params
    success, result = maker_service.delete_maker(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@maker_bp.route('/func/export-maker-list', methods=['GET'])
@errors_handle
@transaction()
def export_maker_list_controller():
    request = maker_bp.current_request.query_params
    success, result = maker_service.export_maker_list(request)
    file_name = f"maker_list_{str(func.now())}"
    if success:
        return Response(
            result,
            headers={
                "Content-disposition": f"attachment; filename={file_name}.csv"
            },
        )
    return error_response({'message': str(result), 'status': 400}, 400)
