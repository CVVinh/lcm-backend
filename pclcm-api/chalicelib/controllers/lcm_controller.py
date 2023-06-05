from chalice.app import Blueprint, Request
from chalice import Response

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import lcm_service
from chalicelib.utils.status_response import success_response, error_response
from datetime import datetime

lcm_bp = Blueprint(__name__)


@lcm_bp.route('/func/get-lcm-list', methods=['GET'])
@errors_handle
@transaction()
def item_list_controller():
    query_params = lcm_bp.current_request.query_params
    try:
        return lcm_service.get_list_lcm(query_params)
    except Exception as e:
        return error_response({"message": str(e)}, 400)


@lcm_bp.route('/func/export-lcm-list', methods=['GET'])
@errors_handle
@transaction()
def export_item_controller():
    query_params = lcm_bp.current_request.query_params
    try:
        success, result = lcm_service.export_list_lcm(query_params)
        file_name = f"lcm_list_{str(datetime.now())}"
        if success:
            return Response(
                result,
                headers={
                    "Content-disposition": f"attachment;filename={file_name}.csv"
                },
            )
    except Exception as e:
        return error_response({"message": str(e)}, 400)
