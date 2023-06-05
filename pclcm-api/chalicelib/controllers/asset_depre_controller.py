from chalice.app import Blueprint, Request
from chalice import Response

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import asset_depre_service
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.validators import asset_depre_schema
from datetime import datetime

asset_depre_bp = Blueprint(__name__)


@asset_depre_bp.route('/func/add-asset-depreciation/', methods=['POST'])
@errors_handle
@transaction()
def add_asset_depre_controller():
    request: Request = asset_depre_bp.current_request
    asset_depre_schema.validate_asset_depre_post(request.json_body)
    try:
        return asset_depre_service.add_asset_depreciation(request.json_body)
    except Exception as e:
        return error_response({"message": str(e)}, 400)


@asset_depre_bp.route('/func/update-asset-depreciation/', methods=['PUT'])
@errors_handle
@transaction()
def update_asset_depre_controller():
    request: Request = asset_depre_bp.current_request
    asset_depre_schema.validate_asset_depre_post(request.json_body)
    try:
        return asset_depre_service.update_asset_depreciation(request.json_body)
    except Exception as e:
        return error_response({'message': str(e)}, 400)


@asset_depre_bp.route('/func/get-asset-depreciation-info/', methods=['GET'])
@errors_handle
@transaction()
def get_asset_depre_info_controller():
    request: Request = asset_depre_bp.current_request
    try:
        assetId: int = request.query_params.get("assetId", "")
        return asset_depre_service.get_asset_depreciation_info(assetId)
    except Exception as e:
        return error_response({"message": str(e)}, 400)


@asset_depre_bp.route('/func/get-asset-depreciation-list/', methods=['GET'])
@errors_handle
@transaction()
def get_asset_depre_list_controller():
    query_params = asset_depre_bp.current_request.query_params
    try:
        return asset_depre_service.get_asset_depreciation_list(query_params)
    except Exception as e:
        return error_response({"message": str(e)}, 400)


@asset_depre_bp.route('/func/export-asset-depreciation-list/', methods=['GET'])
@errors_handle
@transaction()
def get_asset_depre_list_controller():
    query_params = asset_depre_bp.current_request.query_params
    try:
        data = asset_depre_service.export_asset_depreciation_list(query_params)
        file_name = f"asset_depre_list_{str(datetime.now())}"
        return Response(
            data,
            headers={
                "Content-disposition": f"attachment;filename={file_name}.csv"
            },
        )
    except Exception as e:
        return error_response({"message": str(e)}, 400)
