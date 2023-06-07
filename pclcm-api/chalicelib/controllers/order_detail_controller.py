from chalice.app import Blueprint
from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import order_detail_service
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.validators import order_detail_schema
from chalice import Response
from sqlalchemy.sql import func

order_detail_bp = Blueprint(__name__)


@order_detail_bp.route("/func/get-order-detail-list", methods=['GET'])
@errors_handle
@transaction()
def get_order_detail_list_controller():
    request = order_detail_bp.current_request.query_params
    success, result = order_detail_service.get_order_detail_list(request)
    if success:
        return success_response(result)
    return error_response({"message": str(result), "status": 400}, 400)


@order_detail_bp.route("/func/get-order-detail-byIdOrder", methods=["GET"])
@errors_handle
@transaction()
def get_order_detail_byIdOrder_controller():
    request = order_detail_bp.current_request.query_params
    sucess, result = order_detail_service.get_order_detail_byIdOrder(request)
    if (sucess):
        return success_response(result)
    return error_response({"message": str(result), "status": 400}, 400)


@order_detail_bp.route("/func/add-order-detail", methods=["POST"])
@errors_handle
@transaction()
def add_order_detail_controller():
    request = order_detail_bp.current_request.json_body
    order_detail_schema.validate_order_detail_list(request)
    success, result = order_detail_service.add_order_detail(request)
    if (success):
        return success_response({"message": result, "status": 200})
    return error_response({"message": str(result), "status": 400}, 400)

@order_detail_bp.route("/func/update-order-detail", methods=["PUT"])
@errors_handle
@transaction()
def update_order_detail_controller():
    request = order_detail_bp.current_request.json_body
    order_detail_schema.validate_order_detail_list(request)
    success, result = order_detail_service.update_order_detail(request)
    if (success):
        return success_response({"message": result, "status": 200})
    return error_response({"message": str(result), "status": 400}, 400)

@order_detail_bp.route("/func/delete-order-detail", methods=["DELETE"])
@errors_handle
@transaction()
def update_order_detail_controller():
    request = order_detail_bp.current_request.query_params
    success, result = order_detail_service.delete_order_detail(request)
    if (success):
        return success_response({"message": result, "status": 200})
    return error_response({"message": str(result), "status": 400}, 400)

@order_detail_bp.route("/func/export-order-detail", methods=["GET"])
@errors_handle
@transaction()
def export_order_detail_controller():
    request = order_detail_bp.current_request.query_params
    success, result = order_detail_service.export_order_detail_list(request)
    file_name = f"order_detail_list_{str(func.now())}"
    if (success):
        return Response(result, headers={
            "Content-disposition": f"attachment; filename={file_name}.cvs"})
    return error_response({"message": str(result), "status": 400}, 400)

