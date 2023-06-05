from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import gen_code_service
from chalicelib.utils.status_response import error_response, success_response
from sqlalchemy.sql import func
from chalice import Response

gen_code_bp = Blueprint(__name__)


@gen_code_bp.route('/func/get-gen_code-list', methods=['GET'])
@errors_handle
@transaction()
def get_gen_code_list_controller():
    request = gen_code_bp.current_request.query_params
    success, result = gen_code_service.get_gen_code_list(request)
    if success:
        return success_response(result)
    return error_response({'message': str(result), 'status': 400}, 400)
