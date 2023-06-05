from chalicelib.models import session
from chalicelib.models.models import DepreciationRule
from chalicelib.utils.status_response import success_response, error_response
from chalicelib.utils.utils import camel_case_object, object_as_dict, paginate, export
from datetime import datetime
from chalicelib.messages import MessageResponse

message_depreciation_rule_constant = MessageResponse()
message_depreciation_rule_constant.setName("Depreciation Rule")


def field_to_dict(data):
    fields = [
        "depreciationRuleId",
        "depreciationRuleName",
        "fiscalYear",
        "baseYear",
        "amountPerYear"
    ]
    return {field: data[field] for field in fields if field in data}


def get_depreciation_info(ruleId: int):
    depre_item = session.query(DepreciationRule).filter_by(
        depreciationRuleId=ruleId).first()

    if depre_item is None:
        return error_response({"msg": message_depreciation_rule_constant.MESSAGE_ERROR_NOT_EXIST}, 404)

    return success_response({
        "DepreciationRuleInfo": camel_case_object(depre_item),
        "msg": message_depreciation_rule_constant.MESSAGE_SUCCESS_GET_INFO,
        "status": 200
    })


def get_depreciation_list(query_params):
    depre_item = session.query(DepreciationRule)

    if query_params:
        depre_params = {
            "depreciationRuleId", "depreciationRuleName", "fiscalYear", "baseYear", "amountPerYear"}

        # * Use set operation instead of iterating over a list to improve performance
        common_params = depre_params & set(query_params.keys())
        depre_item = depre_item.filter(
            *(getattr(DepreciationRule, param) == query_params[param] for param in common_params))

    result_list = [{**object_as_dict(item)} for item in depre_item]
    paginated_list = paginate(result_list, query_params)

    return success_response({
        "depreList": paginated_list,
        "total": len(result_list),
        "msg": message_depreciation_rule_constant.MESSAGE_SUCCESS_GET_LIST,
        "status": 200,
    })


def add_depreciation_rule(data):
    create_rule = DepreciationRule()

    for key, val in field_to_dict(data).items():
        setattr(create_rule, key, val)

    session.add(create_rule)
    session.commit()
    return success_response({"msg": message_depreciation_rule_constant.MESSAGE_SUCCESS_CREATED, "status": 200})


def update_depreciation_rule(data):
    update_to_rule = session.query(DepreciationRule).filter_by(
        depreciationRuleId=data["depreciationRuleId"]).first()
    if update_to_rule is None:
        return error_response({"msg": message_depreciation_rule_constant.MESSAGE_ERROR_NOT_EXIST}, 404)

    for key, val in field_to_dict(data).items():
        setattr(update_to_rule, key, val)
    session.commit()

    return success_response({"msg": message_depreciation_rule_constant.MESSAGE_SUCCESS_UPDATED, "status": 200})


def delete_depreciation_rule(ruleId: int):
    del_rule = session.query(DepreciationRule).filter_by(
        depreciationRuleId=ruleId).first()

    if del_rule is None:
        return error_response({"msg": message_depreciation_rule_constant.MESSAGE_ERROR_NOT_EXIST}, 404)

    del_rule.isDeleted = 1
    del_rule.deletedAt = datetime.now()

    return success_response({
        "deletedAt": str(del_rule.deletedAt),
        "msg": message_depreciation_rule_constant.MESSAGE_SUCCESS_DELETED,
        "status": 200
    })


def export_depreciation_rule(query_params):
    depre_item = session.query(DepreciationRule)

    if query_params:
        depre_params = {
            "depreciationRuleId", "depreciationRuleName", "fiscalYear", "baseYear", "amountPerYear"}

        # * Use set operation instead of iterating over a list to improve performance
        common_params = depre_params & set(query_params.keys())
        depre_item = depre_item.filter(
            *(getattr(DepreciationRule, param) == query_params[param] for param in common_params))

    result_list = [{**object_as_dict(item)} for item in depre_item]

    return export(result_list)
