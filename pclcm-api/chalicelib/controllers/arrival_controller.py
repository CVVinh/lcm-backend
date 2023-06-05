from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import arrival_service
from chalicelib.validators import arrival_schema
from chalicelib.utils.status_response import success_response, error_response
from sqlalchemy.sql import func
from chalice import Response
from datetime import datetime
arrival_bp = Blueprint(__name__)


@arrival_bp.route("/func/add-arrival", methods=["POST"])
@errors_handle
@transaction()
def add_arrival_controller():
    request = arrival_bp.current_request.json_body
    arrival_schema.validate_post_arrival_list(request)
    success, result = arrival_service.add_arrival(request)
    if success:
        return success_response({"message": result, "stasus": 200})
    return error_response({"message": str(result), "stasus": 400}, 400)


@arrival_bp.route("/func/update-arrival-info", methods=["PUT"])
@errors_handle
@transaction()
def update_arrival_controller():
    request = arrival_bp.current_request.json_body
    arrival_schema.validate_put_arrival_list(request)
    success, result = arrival_service.update_arrival_info(request)
    if success:
        return success_response({"message": result, "stasus": 200})
    return error_response({"message": str(result), "stasus": 400}, 400)


@arrival_bp.route("/func/get-arrival-info", methods=["GET"])
@errors_handle
@transaction()
def get_arrival_info_controller():
    request = arrival_bp.current_request.query_params
    success, result = arrival_service.get_arrival_info(request)
    if success:
        return success_response(result)
    return error_response({"message": str(result), "stasus": 400}, 400)


@arrival_bp.route("/func/delete-arrival-info", methods=["DELETE"])
@errors_handle
@transaction()
def delete_arrival_info_controller():
    request = arrival_bp.current_request.query_params
    success, result = arrival_service.delete_arrival_info(request)
    if success:
        return success_response({"message": result, "stasus": 200})
    return error_response({"message": str(result), "stasus": 400}, 400)


@ arrival_bp.route('/func/get-arrival-list', methods=['GET'])
@errors_handle
@ transaction()
def arrival_list_controller():
    query_params = arrival_bp.current_request.query_params
    try:
        return arrival_service.get_arrival_list(query_params)
    except Exception as e:
        return error_response({"message": str(e)}, 400)


@arrival_bp.route("/func/export-arrival-list", methods=["GET"])
@errors_handle
@transaction()
def export_arrival_list_controller():
    query_params = arrival_bp.current_request.query_params
    try:
        success, result = arrival_service.export_arrival_list(query_params)
        file_name = f"arrival_list{str(datetime.now())}"
        if success:
            return Response(
                result,
                headers={
                    "Content-disposition": f"attachment; filename={file_name}.csv"
                },
            )
    except Exception as e:
        return error_response({"message": str(e)}, 400)
