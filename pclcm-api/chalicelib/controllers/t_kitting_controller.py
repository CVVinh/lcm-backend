from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import t_kitting_service
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.validators import t_kitting_schema

t_kitting_bp = Blueprint(__name__)


@t_kitting_bp.route('/func/get-kitting-info', methods=['GET'])
@errors_handle
@transaction()
def get_t_kitting_info_controller():
    request = t_kitting_bp.current_request.query_params
    success, result = t_kitting_service.get_t_kitting_info(request)
    if success:
        return success_response(result)
    return error_response({'message': str(result), 'status': 400}, 400)


@t_kitting_bp.route('/func/add-kitting', methods=['POST'])
@errors_handle
@transaction()
def add_t_kitting_controller():
    request = t_kitting_bp.current_request.json_body
    t_kitting_schema.validate_post_t_kitting_list(request)
    success, result = t_kitting_service.add_t_kitting(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@t_kitting_bp.route('/func/update-kitting', methods=['PUT'])
@errors_handle
@transaction()
def update_t_kitting_info_controller():
    request = t_kitting_bp.current_request.json_body
    t_kitting_schema.validate_put_t_kitting_list(request)
    success, result = t_kitting_service.update_t_kitting_info(
        request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@t_kitting_bp.route('/func/delete-kitting', methods=['DELETE'])
@errors_handle
@transaction()
def delete_t_kitting_controller():
    request = t_kitting_bp.current_request.query_params
    success, result = t_kitting_service.delete_t_kitting(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)
