from chalice.app import Blueprint

from chalicelib.exceptions.exception_handler import errors_handle
from chalicelib.models.transaction import transaction
from chalicelib.services import outsourcing_company_service
from chalicelib.utils.status_response import error_response, success_response
from chalicelib.validators import outsourcing_company_schema
from sqlalchemy.sql import func
from chalice import Response

outsourcing_company_bp = Blueprint(__name__)


@outsourcing_company_bp.route('/func/get-outsourcing-company-list', methods=['GET'])
@errors_handle
@transaction()
def get_outsourcing_company_list_controller():
    request = outsourcing_company_bp.current_request.query_params
    success, result = outsourcing_company_service.get_outsourcing_company_list(
        request)
    if success:
        return success_response(result)
    return error_response({'message': str(result), 'status': 400}, 400)


@ outsourcing_company_bp.route('/func/add-outsourcing-company', methods=['POST'])
@ errors_handle
@ transaction()
def add_outsourcing_companycontroller():
    request = outsourcing_company_bp.current_request.json_body
    outsourcing_company_schema.validate_post_outsourcing_company_list(
        request)
    success, result = outsourcing_company_service.add_outsourcing_company(
        request)
    if success:
        return success_response({"message": result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@ outsourcing_company_bp.route('/func/update-outsourcing-company-info', methods=['PUT'])
@ errors_handle
@ transaction()
def update_outsourcing_companycontroller():
    request = outsourcing_company_bp.current_request.json_body
    outsourcing_company_schema.validate_put_outsourcing_company_list(
        request)
    success, result = outsourcing_company_service.update_outsourcing_company(
        request)
    if success:
        return success_response({"message": result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@ outsourcing_company_bp.route('/func/get-outsourcing-company-info', methods=['GET'])
@ errors_handle
@ transaction()
def get_outsourcing_company_info_controller():
    request = outsourcing_company_bp.current_request.query_params
    success, result = outsourcing_company_service.get_outsourcing_company_info(
        request)
    if success:
        return success_response(result)
    return error_response({'message': str(result), 'status': 400}, 400)


@ outsourcing_company_bp.route('/func/delete-outsourcing-company', methods=['DELETE'])
@ errors_handle
@ transaction()
def delete_outsourcing_company_controller():
    request = outsourcing_company_bp.current_request.query_params
    success, result = outsourcing_company_service.delete_outsourcing_company(
        request)
    if success:
        return success_response({"message": result, 'status': 200})
    return error_response({'message': str(result), 'status': 400}, 400)


@outsourcing_company_bp.route('/func/export-outsourcing-company-list', methods=['GET'])
@errors_handle
@transaction()
def export_outsourcing_company_list_controller():
    request = outsourcing_company_bp.current_request.query_params
    success, result = outsourcing_company_service.export_outsourcing_company_list(
        request)
    file_name = f"outsourcing_company_list_{str(func.now())}"
    if success:
        return Response(
            result,
            headers={
                "Content-disposition": f"attachment; filename={file_name}.csv"
            },
        )
    return error_response({'message': str(result), 'status': 400}, 400)
