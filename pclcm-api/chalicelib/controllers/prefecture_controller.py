from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import prefecture_service
from chalicelib.utils.status_response import success_response, error_response

prefecture_bp = Blueprint(__name__)


@prefecture_bp.route('/func/get-prefecture-list', methods=['GET'])
@errors_handle
@transaction()
def prefecture_list_controller():
    request = prefecture_bp.current_request
    success, result = prefecture_service.get_prefecture_list(request)
    if success:
        return success_response(result)
    return error_response({"message": str(result), "stasus": 400}, 400)
