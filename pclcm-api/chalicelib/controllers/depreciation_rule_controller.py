from chalice.app import Blueprint, Request
from chalice import Response

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import depreciation_rule_service
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.validators import depreciation_rule_schema
from datetime import datetime

depreciation_rule_bp = Blueprint(__name__)


@depreciation_rule_bp.route('/func/depreciation-rule-info', methods=['GET'])
@errors_handle
@transaction()
def depreciation_rule_info_controller():
    request: Request = depreciation_rule_bp.current_request
    try:
        ruleId: int = request.query_params.get("ruleId", "")
        return depreciation_rule_service.get_depreciation_info(ruleId)
    except Exception as e:
        return error_response({"msg": str(e)}, 400)


@depreciation_rule_bp.route('/func/depreciation-rule-list', methods=['GET'])
@errors_handle
@transaction()
def depreciation_rule_list_controller():
    query_params = depreciation_rule_bp.current_request.query_params
    try:
        return depreciation_rule_service.get_depreciation_list(query_params)
    except Exception as e:
        return error_response({"message": str(e)}, 400)


@depreciation_rule_bp.route('/func/add-depreciation-rule', methods=['POST'])
@errors_handle
@transaction()
def add_item_controller():
    request: Request = depreciation_rule_bp.current_request
    depreciation_rule_schema.validate_depre_rule_post(request.json_body)
    try:
        return depreciation_rule_service.add_depreciation_rule(request.json_body)
    except Exception as e:
        return error_response({"message": str(e)}, 400)


@depreciation_rule_bp.route('/func/update-depreciation-rule', methods=['PUT'])
@errors_handle
@transaction()
def update_item_controller():
    request: Request = depreciation_rule_bp.current_request
    depreciation_rule_schema.validate_depre_rule_post(request.json_body)
    try:
        return depreciation_rule_service.update_depreciation_rule(request.json_body)
    except Exception as e:
        return error_response({'msg': str(e)}, 400)


@depreciation_rule_bp.route('/func/delete-depreciation-rule', methods=['DELETE'])
@errors_handle
@transaction()
def delete_item_controller():
    request: Request = depreciation_rule_bp.current_request
    try:
        ruleId: int = request.query_params.get("ruleId", "")
        return depreciation_rule_service.delete_depreciation_rule(ruleId)
    except Exception as e:
        return error_response({"msg": str(e)}, 400)


@depreciation_rule_bp.route('/func/export-depreciation-rule', methods=['GET'])
@errors_handle
@transaction()
def export_item_controller():
    query_params = depreciation_rule_bp.current_request.query_params
    try:
        success, result = depreciation_rule_service.export_depreciation_rule(
            query_params)
        file_name = f"depreciation_rule_list_{str(datetime.now())}"
        if success:
            return Response(
                result,
                headers={
                    "Content-disposition": f"attachment;filename={file_name}.csv"
                },
            )
    except Exception as e:
        return error_response({"message": str(e)}, 400)
