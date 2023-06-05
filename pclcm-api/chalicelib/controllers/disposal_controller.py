from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import disposal_service
from chalicelib.validators import disposal_schema
from chalicelib.utils.status_response import success_response, error_response


disposal_bp = Blueprint(__name__)


@disposal_bp.route("/func/add-disposal", methods=["POST"])
@errors_handle
@transaction()
def add_repairing_controller():
    request = disposal_bp.current_request.json_body
    disposal_schema.validate_disposal_list(request)
    try:
        return disposal_service.add_disposal(request)
    except Exception as e:
        return error_response({"message": str(e)}, 400)


@disposal_bp.route("/func/update-disposal-info", methods=["PUT"])
@errors_handle
@transaction()
def update_disposal_controller():
    request = disposal_bp.current_request.json_body
    disposal_schema.validate_disposal_list(request)
    try:
        return disposal_service.update_disposal(request)
    except Exception as e:
        return error_response({"message": str(e)}, 400)


@disposal_bp.route("/func/get-disposal-info", methods=["GET"])
@errors_handle
@transaction()
def get_disposal_info_controller():
    param = disposal_bp.current_request.query_params
    try:
        assetId: int = param.get("assetId", "")
        return disposal_service.get_disposal_info(assetId)
    except Exception as e:
        return error_response({"message": str(e)}, 400)


@disposal_bp.route("/func/delete-disposal", methods=["DELETE"])
@errors_handle
@transaction()
def delete_disposal_info_controller():
    param = disposal_bp.current_request.query_params
    try:
        assetId: int = param.get("assetId", "")
        return disposal_service.delete_disposal(assetId)
    except Exception as e:
        return error_response({"message": str(e)}, 400)
