from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import pickup_service
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.validators import pickup_schema
from chalice import Response
import datetime
pickup_bp = Blueprint(__name__)


@pickup_bp.route('/func/add-pickup', methods=['POST'])
@errors_handle
@transaction()
def pickup_add_controller():
    request = pickup_bp.current_request.json_body
    pickup_schema.validate_pickup_post(request)
    success, result = pickup_service.create_pickup(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@pickup_bp.route('/func/update-pickup', methods=['PUT'])
@errors_handle
@transaction()
def pickup_update_controller():
    request = pickup_bp.current_request.json_body
    pickup_schema.validate_pickup_put(request)
    success, result = pickup_service.update_pickup(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@pickup_bp.route('/func/delete-pickup', methods=['DELETE'])
@errors_handle
@transaction()
def pickup_delete_controller():
    request = pickup_bp.current_request.query_params
    success, result = pickup_service.delete_pickup(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@pickup_bp.route('/func/get-pickup-info', methods=['GET'])
@errors_handle
@transaction()
def get_pickup_info_controller():
    request = pickup_bp.current_request.query_params
    success, result = pickup_service.get_pickup_info(request)
    if success:
        return success_response(result)
    return error_response({'message': str(result), 'status': 400}, 400)
