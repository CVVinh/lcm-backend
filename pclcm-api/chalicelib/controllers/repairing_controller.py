from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import repairing_service
from chalicelib.validators import repairing_schema
from chalicelib.utils.status_response import success_response, error_response


repairing_bp = Blueprint(__name__)


@repairing_bp.route("/func/add-repairing", methods=["POST"])
@errors_handle
@transaction()
def add_repairing_controller():
    request = repairing_bp.current_request
    repairing_schema.validate_repair_list(request.json_body)
    try:
        return repairing_service.add_repairing(request.json_body)
    except Exception as e:
        return error_response({"message": str(e)}, 400)


@repairing_bp.route("/func/update-repairing-info", methods=["PUT"])
@errors_handle
@transaction()
def update_repairing_controller():
    request = repairing_bp.current_request
    repairing_schema.validate_repair_list(request.json_body)
    try:
        return repairing_service.update_repairing(request.json_body)
    except Exception as e:
        return error_response({"message": str(e)}, 400)


@repairing_bp.route("/func/get-repairing-info", methods=["GET"])
@errors_handle
@transaction()
def get_repairing_info_controller():
    param = repairing_bp.current_request.query_params
    try:
        assetId: int = param.get("assetId", "")
        return repairing_service.get_repairing_info(assetId)
    except Exception as e:
        return error_response({"message": str(e)}, 400)


@repairing_bp.route("/func/delete-repairing", methods=["DELETE"])
@errors_handle
@transaction()
def delete_repairing_info_controller():
    param = repairing_bp.current_request.query_params
    try:
        assetId: int = param.get("assetId", "")
        return repairing_service.delete_repairing(assetId)
    except Exception as e:
        return error_response({"message": str(e)}, 400)
