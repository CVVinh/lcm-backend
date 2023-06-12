from chalice.app import Blueprint
from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import order_service
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.validators import order_schema
from chalice import Response
import datetime 
from sqlalchemy.sql import func

order_bp = Blueprint(__name__)

@order_bp.route('/func/get-order-list', methods=['GET'])
@errors_handle
@transaction()
def get_order_list_controller():
    request = order_bp.current_request.query_params
    success, result = order_service.get_order_list(request)
    if success:
        return success_response(result)
    return error_response({"message": str(result), "status": 400}, 400)

@order_bp.route('/func/get-order-info', methods=['GET'])
@errors_handle
@transaction()
def get_order_controller():
    request = order_bp.current_request.query_params    
    success, result = order_service.get_order_info(request)
    if(success):
        return success_response(result)
    return error_response({"message": str(result), "status": 400}, 400)

@order_bp.route('/func/add-order', methods=['POST'])
@errors_handle
@transaction()
def add_order_controller():
    request = order_bp.current_request.json_body
    order_schema.validate_order_list(request)
    success, result = order_service.add_order(request)
    if(success):
        return success_response({"message": result, "status": 200})
    return error_response({"message": str(result), "status": 400}, 400)


@order_bp.route('/func/update-order', methods=['PUT'])
@errors_handle
@transaction()
def update_order_controller():
    request = order_bp.current_request.json_body
    order_schema.validate_order_list(request)
    success, result = order_service.update_order_info(request)
    if(success):
        return success_response({"message": result, "status": 200})
    return error_response({"message": str(result), "status": 400}, 400)

@order_bp.route('/func/delete-order', methods=['DELETE'])
@errors_handle
@transaction()
def delete_order_controller():
    request = order_bp.current_request.query_params
    success, result = order_service.delete_order(request)
    if(success):
        return success_response({"message": result, "status": 200})
    return error_response({"message": str(result), "status": 400}, 400)

@order_bp.route('/func/delete-order-hard', methods=['DELETE'])
@errors_handle
@transaction()
def delete_order_controller():
    request = order_bp.current_request.query_params
    success, result = order_service.delete_order_hard(request)
    if(success):
        return success_response({"message": result, "status": 200})
    return error_response({"message": str(result), "status": 400}, 400)

@order_bp.route('/func/export-order', methods=['GET'])
@errors_handle
@transaction()
def export_order_controller():
    request = order_bp.current_request.query_params
    success, result = order_service.export_orderlist(request)
    file_name = f"order_detail_list_{str(func.now())}"
    if(success):
        return Response(result, headers={
            "Content-disposition": f"attachment; filename={file_name}.cvs"
        })
    return error_response({"message": str(result), "status": 400}, 400)
