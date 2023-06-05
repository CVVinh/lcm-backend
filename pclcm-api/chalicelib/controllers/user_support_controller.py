import traceback
from chalice.app import Blueprint, Request
from chalice import Response

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import user_support_service
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.validators import user_request_schema

#メッセージ
support_bp = Blueprint(__name__)

@support_bp.route('/func/get-message-list/', methods=['GET'])
@errors_handle
@transaction()
def message_list_controller():
    print("メッセージ取得APIスタート")
    try:
        response = user_support_service.get_message_list()
        return response
    except Exception as e:
        return error_response({"message": str(e)}, 400)

#申請検索
@support_bp.route('/func/get-request-list/', methods=['GET'])
@errors_handle
@transaction()
def riquest_list_controller():
    print("申請検索APIスタート")
    try:
        query_params = support_bp.current_request.query_params
        response = user_support_service.get_request_list(query_params)
        return response
    except Exception as e:
        return error_response({"message": str(e)}, 400)

#申請詳細取得
@support_bp.route('/func/get-request-info', methods=['GET'])
@errors_handle
@transaction()
def get_request_info_controller():
    print("申請取得APIスタート")
    request: Request = support_bp.current_request
    try:
        request_id: int = request.query_params.get("request_id", "")
        response = user_support_service.get_request_info(int(request_id))
        return response
    except Exception as e:
        return error_response({"msg": str(e)}, 400)

@support_bp.route('/func/add-request/', methods=['POST'])
@errors_handle
@transaction()
def add_request_controller():
    request: Request = support_bp.current_request
    user_request_schema.validate_item_post(request.json_body)
    try:
        response = user_support_service.add_request(request.json_body)
        return response
    except Exception as e:
        return error_response({"message": str(e)}, 400)
