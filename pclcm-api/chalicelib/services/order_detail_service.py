from sqlalchemy.sql import func
from chalicelib.models.models import (
    OrderMaster, 
    OrderDetailMaster,
    )
from chalicelib.models import session
from chalicelib.utils.status_response import success_response
from chalicelib.utils.utils import add_update_object, object_as_dict, paginate, export, format_day_and_bool_dict
from chalicelib.services.asset_service import create_asset
from chalicelib.gen_codes import GenCodeConstant
from chalicelib.messages import MessageResponse

gen_code_constant = GenCodeConstant()
message_order_detail_constant = MessageResponse()
message_order_detail_constant.setName("OrderDetailMaster")

def filter_param_get_list_order_detail(query_params):
    query_list_order_detail = session.query(OrderDetailMaster)
    if(query_params):
        params_search_order_detail = ['orderId', 'orderDetailtId']
        for param in params_search_order_detail:
            if(param in query_params):
                query_list_order_detail = query_list_order_detail.filter(getattr(OrderDetailMaster, param) == query_params[param])
            
    query_list_order_detail = query_list_order_detail.filter(OrderDetailMaster.isDeleted == 0)
    return [object_as_dict(order) for order in query_list_order_detail.all()]        

def filter_param_get_list_order_detail_join_table(query_params):
    query_list_order_details = session.query(OrderDetailMaster.orderDetailtId, OrderDetailMaster.descriptionOrderDetail, OrderDetailMaster.statusOrderDetail, OrderMaster.orderId, OrderMaster.companyOrder, OrderMaster.addressOrder, OrderMaster.descriptionOrder).join(OrderMaster, OrderMaster.orderId == OrderDetailMaster.orderId, isouter=True)
    if(query_params):
        if "orderId" in query_params:
            query_list_order_details = query_list_order_details.filter(OrderMaster.orderId == query_params["orderId"])
            
        if "orderDetailtId" in query_params:
            query_list_order_details = query_list_order_details.filter(OrderDetailMaster.orderDetailtId == query_params["orderDetailtId"])
            
    query_list_order_details = query_list_order_details.filter(OrderDetailMaster.isDeleted == 0)
    
    result_list = []
    for item in query_list_order_details.all():
        object = {**item}
        obj_order = {
            "orderDetailtId": object["orderDetailtId"],
            "descriptionOrderDetail": object["descriptionOrderDetail"],
            "statusOrderDetail": object["statusOrderDetail"],
            "order": {
                "orderId": object["orderId"],
                "companyOrder": object["companyOrder"],
                "addressOrder": object["addressOrder"],
                "descriptionOrder": object["descriptionOrder"],
            }
        }
        result_list.append(obj_order)
    return result_list    
                
def get_order_detail_list(query_params):
    #filter_param_get_list = filter_param_get_list_order_detail(query_params)
    filter_param_get_list = filter_param_get_list_order_detail_join_table(query_params)
    paginated_lst = paginate(filter_param_get_list, query_params)
    return (True, {"orderDetail": paginated_lst,
                   "total": len(filter_param_get_list), 
                   "message": message_order_detail_constant.MESSAGE_SUCCESS_GET_LIST, 
                   "status": 200})

def get_order_detail_byIdOrder(query_params):
    order_detail_id = query_params.get('orderDetailtId')
    if(order_detail_to_info := session.query(OrderDetailMaster).filter(OrderDetailMaster.orderDetailtId == order_detail_id, OrderDetailMaster.isDeleted == 0).first()):
        
        tmp_order_detail_info = {"orderDetail": {**object_as_dict(order_detail_to_info, True)},
                                 "total": 1,
                                 "message": message_order_detail_constant.MESSAGE_SUCCESS_GET_INFO, 
                                 "status": 200}
        return (True, tmp_order_detail_info)
    return (False, message_order_detail_constant.MESSAGE_ERROR_NOT_EXIST)

def add_order_detail(order_detail_obj):
    create_order = OrderDetailMaster()
    session.add(add_update_object(order_detail_obj, create_order))
    session.commit()
    return (True, message_order_detail_constant.MESSAGE_SUCCESS_CREATED)

def update_order_detail(query_params):
    order_detail_id = query_params.get("orderDetailtId")
    if(update_order_detail := session.query(OrderDetailMaster).filter(OrderDetailMaster.orderDetailtId == order_detail_id, OrderDetailMaster.isDeleted == 0).first()):
        add_update_object(query_params, update_order_detail)
        update_order_detail.modifiedAt = func.now()
        session.commit()
        return (True, message_order_detail_constant.MESSAGE_SUCCESS_UPDATED)
    return (False, message_order_detail_constant.MESSAGE_ERROR_NOT_EXIST)   


def delete_order_detail(query_params):
    order_detail_id = query_params.get("orderDetailtId")
    if(delete_order_detail := session.query(OrderDetailMaster).filter(OrderDetailMaster.orderDetailtId == order_detail_id, OrderDetailMaster.isDeleted == 0).first()):
        delete_order_detail.isDeleted = 1
        delete_order_detail.deletedAt = func.now()
        return (True, message_order_detail_constant.MESSAGE_SUCCESS_DELETED)
    return (False, message_order_detail_constant.MESSAGE_ERROR_NOT_EXIST)  

def export_order_detail_list(query_params):
    return export(filter_param_get_list_order_detail(query_params))
