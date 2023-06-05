from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import using_service
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.validators import using_schema

using_bp = Blueprint(__name__)


@using_bp.route('/func/get-using-info', methods=['GET'])
@errors_handle
@transaction()
def get_using_info_controller():
    request = using_bp.current_request.query_params
    success, result = using_service.get_using_info(request)
    if success:
        return success_response(result)
    return error_response({'message': str(result), 'status': 400}, 400)


@using_bp.route('/func/add-using', methods=['POST'])
@errors_handle
@transaction()
def add_using_controller():
    request = using_bp.current_request.json_body
    using_schema.validate_post_using_list(request)
    success, result = using_service.add_using(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@using_bp.route('/func/update-using', methods=['PUT'])
@errors_handle
@transaction()
def update_using_info_controller():
    request = using_bp.current_request.json_body
    using_schema.validate_put_using_list(request)
    success, result = using_service.update_using_info(
        request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@using_bp.route('/func/delete-using', methods=['DELETE'])
@errors_handle
@transaction()
def delete_using_controller():
    request = using_bp.current_request.query_params
    success, result = using_service.delete_using(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)
