from chalice.app import Blueprint
from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import order_service
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.validators import *
from chalice import Response
import datetime 

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











