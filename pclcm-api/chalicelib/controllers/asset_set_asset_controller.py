from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import asset_set_asset_service
from chalicelib.validators import asset_set_asset_schema
from chalicelib.utils.status_response import success_response, error_response
from sqlalchemy.sql import func
from chalice import Response
from datetime import datetime
asset_set_asset_bp = Blueprint(__name__)


@asset_set_asset_bp.route("/func/add-asset-set-asset", methods=["POST"])
@errors_handle
@transaction()
def add_asset_set_asset_controller():
    request = asset_set_asset_bp.current_request.json_body
    asset_set_asset_schema.validate_post_asset_set_asset_list(request)
    success, result = asset_set_asset_service.add_asset_set_asset(request)
    if success:
        return success_response({"message": result, "stasus": 200})
    return error_response({"message": str(result), "stasus": 400}, 400)


@asset_set_asset_bp.route('/func/delete-asset-set-asset', methods=['DELETE'])
@errors_handle
@transaction()
def asset_set_asset_delete_controller():
    request = asset_set_asset_bp.current_request.query_params
    success, result = asset_set_asset_service.delete_asset_set_asset(request)
    if success:
        return success_response({"message": result, "stasus": 200})
    return error_response({"message": str(result), "stasus": 400}, 400)
