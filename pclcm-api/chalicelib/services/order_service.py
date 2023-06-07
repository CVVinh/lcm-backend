from sqlalchemy.sql import func
from chalicelib.models.models import (
    OrderMaster, 
    OrderDetailMaster,
    )
from chalicelib.models import session
from chalicelib.utils.status_response import success_response
from chalicelib.utils.utils import add_update_object, object_as_dict, paginate, export, format_day_and_bool_dict
from chalicelib.services.order_detail_service import add_order_detail, delete_order_detail
from chalicelib.gen_codes import GenCodeConstant
from chalicelib.messages import MessageResponse

gen_code_constant = GenCodeConstant()
message_order_constant = MessageResponse()
message_order_constant.setName("OrderMaster")

def filter_param_get_list_order(query_params):
    """_summary_

   Query and search gen code with parameters

    Arguments:
        query_params: param search
    Returns:
        List: Returning a list object.
    """
    query_list_order = session.query(OrderMaster)
    if query_params:
        params_search_order = ['orderId']
        for param in params_search_order:
            if(param in query_params):
                query_list_order = query_list_order.filter(getattr(OrderMaster, param) == query_params[param])
    
    query_list_order = query_list_order.filter(OrderMaster.isDeleted == 0)
    return [object_as_dict(order) for order in query_list_order.all()]        


def filter_param_get_list_order_join_table(query_params):
    """_summary_

   Query and search gen code with parameters

    Arguments:
        query_params: param search
    Returns:
        List: Returning a list object.
    """
    query_list_order = session.query(OrderMaster).filter(OrderMaster.isDeleted == 0)
    query_list_order_detail = session.query(OrderDetailMaster).filter(OrderDetailMaster.isDeleted == 0)
    if query_params:
        params_search_order = ['orderId']
        for param in params_search_order:
            if(param in query_params):
                query_list_order = query_list_order.filter(getattr(OrderMaster, param) == query_params[param])
                
    query_list_order = [object_as_dict(order) for order in query_list_order.all()]
    
    result_list = []
    for item in query_list_order:
        getOrderDetail = query_list_order_detail.filter(OrderDetailMaster.orderId == item["orderId"], OrderDetailMaster.isDeleted == 0)
        obj_order = {
            "orderId": item["orderId"],
            "companyOrder": item["companyOrder"],
            "addressOrder": item["addressOrder"],
            "descriptionOrder": item["descriptionOrder"],
            "orderDetail": [object_as_dict(order) for order in getOrderDetail.all()]
        }
        result_list.append(obj_order)
    return result_list  

def get_order_list(query_params):
    # depre_item = session.query(OrderMaster)

    # if query_params:
    #     depre_params = {"orderId"}

    #     * Use set operation instead of iterating over a list to improve performance
    #     common_params = depre_params & set(query_params.keys())
    #     depre_item = depre_item.filter(
    #         *(getattr(OrderMaster, param) == query_params[param] for param in common_params))

    # result_list = [{**object_as_dict(item)} for item in depre_item]
    # paginated_list = paginate(result_list, query_params)
    
    # return success_response({
    #     "orderList": paginated_list,
    #     "total": len(result_list),
    #     "msg": message_order_constant.MESSAGE_SUCCESS_GET_LIST,
    #     "status": 200,
    # })
    
    #filter_param_get_list = filter_param_get_list_order(query_params)
    filter_param_get_list = filter_param_get_list_order_join_table(query_params)
    paginated_lst = paginate(filter_param_get_list, query_params)
    return (True, {"orderList": paginated_lst,
                   "total": len(filter_param_get_list),
                   "message": message_order_constant.MESSAGE_SUCCESS_GET_LIST,
                   "status": 200})

def get_order_info(query_params):
    """_summary_

    get 1 record for order by id
    Arguments:
        query_params: param search
    Returns:
        Response: Returning a message and a object include obj Order
    """
    order_id = query_params.get("orderId")
    if(order_to_info := session.query(OrderMaster).filter(OrderMaster.orderId == order_id, OrderMaster.isDeleted == 0).first()):
        tmp_order_info = {
            **object_as_dict(order_to_info, True), 
            "mesage": message_order_constant.MESSAGE_SUCCESS_GET_INFO,
            "status": 200
        }
        return (True, tmp_order_info)
    return (False, message_order_constant.MESSAGE_ERROR_NOT_EXIST)

def add_order(base_obj):
    """
    Create request and add record for base.

    Argument:
        base_obj: request body
    Returns:
        The message.
    """
    create_order = OrderMaster()
    session.add(add_update_object(base_obj, create_order))
    session.commit()
    return (True, message_order_constant.MESSAGE_SUCCESS_CREATED)

def update_order_info(query_params):
    """_summary_

    update 1 record for base by id.add()
    Argument:
        query_params: json body
    Returns: 
        Response: Returning a message.
    """
    order_id = query_params.get("orderId")
    if(update_to_order := session.query(OrderMaster).filter(OrderMaster.orderId == order_id, OrderMaster.isDeleted == 0).first()):
        # print({**object_as_dict(update_to_order, True)})
        # print(order_id)
        add_update_object(query_params, update_to_order)
        update_to_order.modifiedAt = func.now()
        session.commit()
        return (True, message_order_constant.MESSAGE_SUCCESS_UPDATED)
    return (False, message_order_constant.MESSAGE_ERROR_NOT_EXIST)

def delete_order(query_params):
    """_summary_

    Delete a record for base by id.
    Argument:
        query_params: parameter
    Returns: 
        The message.
    """
    order_id = query_params.get("orderId")
    if(delete_to_order := session.query(OrderMaster).filter(OrderMaster.orderId == order_id, OrderMaster.isDeleted == False).first()):
        delete_to_order.isDeleted = 1
        delete_to_order.deletedAt = func.now()
        
        get_order_details = session.query(OrderDetailMaster).filter(OrderDetailMaster.orderId == order_id)
        
        for item  in get_order_details:
            delete_order_detail({"orderDetailtId":item.orderDetailtId})
        
        return (True, message_order_constant.MESSAGE_SUCCESS_DELETED)
    return (False, message_order_constant.MESSAGE_ERROR_NOT_EXIST)


def delete_order_hard(query_params):
    """
    Create request and add record for base.

    Argument:
        base_obj: request body
    Returns:
        The message.
    """
    order_id = query_params.get("orderId")
    if(delete_to_order := session.query(OrderMaster).filter(OrderMaster.orderId == order_id, OrderMaster.isDeleted == False).first()):
        session.delete(delete_to_order)
        session.commit()
        return (True, message_order_constant.MESSAGE_SUCCESS_DELETED)
    return (False, message_order_constant.MESSAGE_ERROR_NOT_EXIST)


def export_orderlist(query_params):
    return export(filter_param_get_list_order(query_params))




