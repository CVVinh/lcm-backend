from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import shipping_service
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.validators import shipping_schema
from chalice import Response
import datetime
shipping_bp = Blueprint(__name__)


@shipping_bp.route('/func/add-shipping', methods=['POST'])
@errors_handle
@transaction()
def shipping_add_controller():
    request = shipping_bp.current_request.json_body
    shipping_schema.validate_shipping_post(request)
    success, result = shipping_service.create_shipping(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@shipping_bp.route('/func/update-shipping', methods=['PUT'])
@errors_handle
@transaction()
def shipping_update_controller():
    request = shipping_bp.current_request.json_body
    shipping_schema.validate_shipping_put(request)
    success, result = shipping_service.update_shipping(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@shipping_bp.route('/func/delete-shipping', methods=['DELETE'])
@errors_handle
@transaction()
def shipping_delete_controller():
    request = shipping_bp.current_request.query_params
    success, result = shipping_service.delete_shipping(request)
    if success:
        return success_response({'message': result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@shipping_bp.route('/func/get-shipping-info', methods=['GET'])
@errors_handle
@transaction()
def get_shipping_info_controller():
    request = shipping_bp.current_request.query_params
    success, result = shipping_service.get_shipping_info(request)
    if success:
        return success_response(result)
    return error_response({'message': str(result), 'status': 400}, 400)


@shipping_bp.route('/func/get-shipping-list', methods=['GET'])
@errors_handle
@transaction()
def get_shipping_list_controller():
    request = shipping_bp.current_request.query_params
    success, result = shipping_service.get_shipping_list(request)
    if success:
        return success_response(result)
    return error_response({'message': str(result), 'status': 400}, 400)


@shipping_bp.route('/func/export-shipping-list-csv', methods=['GET'])
@errors_handle
@transaction()
def get_shipping_list_export_controller():
    request = shipping_bp.current_request.query_params
    success, result = shipping_service.export_shipping_list_csv(request)
    file_name = f"shipping_list_{str(datetime.datetime.now())}"
    if success:
        return Response(
            result,
            headers={
                "Content-disposition": f"attachment; filename={file_name}.csv"
            },
        )
    return error_response({"message": str(result), "stasus": 400}, 400)
