from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import account_service
# from chalicelib.validators import account_schema
from chalicelib.utils.status_response import success_response, error_response
from sqlalchemy.sql import func
from chalice import Response

account_bp = Blueprint(__name__)


@account_bp.route('/func/get-account-list', methods=['GET'])
@errors_handle
@transaction()
def account_list_controller():
    request = account_bp.current_request.query_params
    success, result = account_service.get_account_list(request)
    if success:
        return success_response(result)
    return error_response({'message': str(result), 'status': 400}, 400)
 