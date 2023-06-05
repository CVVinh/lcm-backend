import datetime
import pytz
import uuid
import re
from chalicelib.models import session
from chalicelib.utils.status_response import success_response, error_response
from sqlalchemy import or_
from collections.abc import MutableMapping
from chalicelib.models.models import (
    Asset,
    Kitting,
    Shipping,
    PickUp,
    Repairing,
    Disposal,
    Use,
    AssetSetAsset,
    Asset
)
from chalicelib.messages import MessageResponse
from chalicelib.gen_codes import GenCodeConstant
gen_code_constant = GenCodeConstant()
message_check_operation_constant = MessageResponse()
message_check_operation_constant.setName("Asset")


def generate_id() -> str:
    return uuid.uuid4()


def get_current_jst_time():
    return datetime.now(tz=pytz.timezone("Asia/Tokyo"))


def convert_time_to_iso(date_time: datetime) -> str:
    return date_time.strftime("%Y-%m-%dT%H:%M:%S.%f%z")


def check_operation_status(data):
    """Check if the Asset is already in operation process

    Args:
        data (assetId): request body

    Returns:
        response: error response if assetId already existed
    """
    # * Check if the Asset record exists in database and is not disposed
    asset_lst = (
        session.query(Asset)
        .filter(Asset.assetId == data["assetId"], Asset.isDeleted == 0)
        .first()
    )
    if asset_lst is None:
        return error_response({"msg": message_check_operation_constant.MESSAGE_ERROR_NOT_EXIST}, 404)
    elif asset_lst.assetStatus == 7:
        return error_response({"msg": message_check_operation_constant.MESSAGE_ERROR_DISPOSED}, 404)

    # * Check if the asset has been added into operation process
    kitting_opr = (
        session.query(Kitting)
        .filter(Kitting.assetId == data["assetId"])
        .filter(or_(Kitting.kittingStatus == gen_code_constant.KITTING_STATUS_PRE_KITTING,
                    Kitting.kittingStatus == gen_code_constant.KITTING_STATUS_KITTING))
        .filter(Kitting.isDeleted == 0)
        .first()
    )
    shipping_opr = (
        session.query(Shipping)
        .filter(Shipping.assetId == data["assetId"])
        .filter(or_(Shipping.shippingStatus == gen_code_constant.SHIPPING_RECEPTION_STATUS_PRE_SHIPPING,
                    Shipping.shippingStatus == gen_code_constant.SHIPPING_STATUS_SHIPPING))
        .filter(Shipping.isDeleted == 0)
        .first()
    )
    pickup_opr = (
        session.query(PickUp)
        .filter(PickUp.assetId == data["assetId"])
        .filter(or_(PickUp.pickUpStatus == gen_code_constant.PICK_UP_STATUS_PRE_PICKING_UP,
                    PickUp.pickUpStatus == gen_code_constant.PICK_UP_STATUS_PICKING_UP))
        .filter(PickUp.isDeleted == 0)
        .first()
    )
    repair_opr = (
        session.query(Repairing)
        .filter(Repairing.assetId == data["assetId"])
        .filter(or_(Repairing.repairingStatus == gen_code_constant.REPAIRING_STATUS_PRE_REPAIRING,
                    Repairing.repairingStatus == gen_code_constant.REPAIRING_STATUS_REPAIRING))
        .filter(Repairing.isDeleted == 0)
        .first()
    )
    disposal_opr = (
        session.query(Disposal)
        .filter(Disposal.assetId == data["assetId"])
        .filter(or_(Disposal.disposalStatus == gen_code_constant.DISPOSAL_STATUS_PRE_DISPOSING,
                    Disposal.disposalStatus == gen_code_constant.DISPOSAL_STATUS_DISPOSING))
        .filter(Disposal.isDeleted == 0)
        .first()
    )
    use_opr = (
        session.query(Use)
        .filter(Use.assetId == data["assetId"])
        .filter(or_(Use.useStatus == gen_code_constant.USE_STATUS_PRE_USING,
                    Use.useStatus == gen_code_constant.USE_STATUS_USING))
        .filter(Use.isDeleted == 0)
        .first()
    )

    # * Return error if assetId exists in any of other tables
    if (
        kitting_opr
        or shipping_opr
        or pickup_opr
        or repair_opr
        or disposal_opr
        or use_opr
    ):
        return error_response({"msg": message_check_operation_constant.MESSAGE_ERROR_OPERATING}, 400)


# Convert nested dictionary into flattened dictionary


def convert_flatten(d, parent_key="", sep="_"):
    items = []
    for k, v in d.items():
        new_key = parent_key + sep + k if parent_key else k

        if isinstance(v, MutableMapping):
            items.extend(convert_flatten(v, new_key, sep=sep).items())
        else:
            items.append((new_key, v))
    return dict(items)


def snake_to_camel(word):
    components = word.split("_")
    return components[0] + "".join(x.title() for x in components[1:])


def camel_to_snake(word):
    comp = re.compile("((?<=[a-z0-9])[A-Z]|(?!^)[A-Z](?=[a-z]))")
    return comp.sub(r"_\1", word).lower()


def object_as_dict(self, is_detail=False):
    """
    Convert records in database into dictionary object
    Args:
        self: queries
        is_detail: an bool
    Returns:
        object: dict object from queries
    """
    try:
        dict_ = {}
        for key in self.__mapper__.c.keys():
            dict_[key] = getattr(self, key)
            format_day_and_bool_dict(dict_, key, is_detail)
        return dict_
    except Exception as e:
        return {}


def format_day_and_bool_dict(dict_, key, is_detail=False):
    """
    Convert value type datetime.date, datetime.datetime to string. type bool to integer
    Args:
        dict_: a dict
        key: a string
        is_detail: an bool
    """
    format_day = '%Y-%m-%d %H:%M:%S' if is_detail else '%Y-%m-%d'
    if isinstance(dict_[key], (datetime.date, datetime.datetime)):
        dict_[key] = dict_[key].strftime(format_day)
    elif isinstance(dict_[key], bool):
        dict_[key] = int(dict_[key])


def camel_case_object(self):
    """Convert keys in object_as_dict function into camelCase

    Args:
        dict: dict returned from object_as_dict

    Returns:
        dict: dict with camelCase keys
    """
    return {snake_to_camel(key): val for (key, val) in object_as_dict(self).items()}


def add_update_object(data, obj):
    """
    Convert field from parameter to dictionary.

    Args:
        data (obj): json body
        obj (obj): an model object
    Returns:
        dict: Returning dictionary.
    """
    fields = object_as_dict(obj)
    attr_dict = {field: data[field] for field in fields if field in data}
    for key, val in attr_dict.items():
        setattr(obj, key, val)
    return obj


def paginate(result_list, query_params):
    """
    Paginate processing and search with pageNum, pageSize.

    Arguments:
        result_list (list): a list
        query_params: MultiDict
    Returns:
        List: Returning a list.
    """
    page_num = 1
    page_size = len(result_list)
    if query_params:
        page_num = (
            int(query_params["pageNum"]) if query_params.get(
                "pageNum") else page_num
        )
        page_size = (
            int(query_params["pageSize"]) if query_params.get(
                "pageSize") else page_size
        )

    start = (page_num - 1) * page_size
    end = start + page_size
    return result_list[slice(start, end)]


def export(export_list):
    """
    Change the list to export CSV.

    Arguments:
        export_list (list): a list
    Returns:
        File: Returning a file.
    """
    if len(export_list) <= 0:
        return (False, "Failed!")
    str_body = ""
    str_header = "".join(f"{key}," for key in export_list[0].keys())
    for item in export_list:
        for key, value in item.items():
            if value is None:
                value = ""
            str_body += f"{str(value)},"
        str_body += "\n"
    return (True, (str_header + "\n" + str_body))


def get_list_asset_is_set(asset_id):
    """
    Get 1 asset list if id of it is main.

    Arguments:
        asset_id : an integer
    Returns:
        List: Returning a asset list.
    """
    # Query AssetSetAsset, filter asset id
    query_asset_set_asset = session.query(AssetSetAsset).filter(
        Asset.assetId == AssetSetAsset.assetId, Asset.assetId == asset_id).first()
    list_assets = []
    if query_asset_set_asset:
        # Query Asset and is main of AssetSetAsset, filter asset id set
        query_list_asset_is_main = session.query(Asset, AssetSetAsset.isMain).join(
            AssetSetAsset, AssetSetAsset.assetId == Asset.assetId).filter(
            AssetSetAsset.assetIdSet == query_asset_set_asset.assetIdSet).all()
        # Create loop of lists asset is isSet, assign it to an object and then assign to a new list.
        for asset in query_list_asset_is_main:
            obj_list_asset = object_as_dict(asset[0], True)
            obj_list_asset["isMain"] = int(asset[1])
            list_assets.append(obj_list_asset)
    return list_assets


def check_is_main_is_set(asset_id):
    """
    Check asset id in AssetSetAsset, if id exist then it is Set and filter is main in AssetSetAsset.

    Arguments:
        asset_id : an integer
    Returns:
        dict: Returning a dict.
    """
    check_exist_is_set = session.query(AssetSetAsset).filter(
        AssetSetAsset.assetId == asset_id).first()
    obj = {}
    if check_exist_is_set:
        obj["isSet"] = 1
        obj["isMain"] = int(check_exist_is_set.isMain)
    else:
        obj["isSet"] = 0
        obj["isMain"] = 0
    return obj


def check_param_error(self, json_schema):
    """
    Check if the parameters are error.

    Arguments:
        json_schema : json body
    Returns:
        String: Returning a string.
    """
    for param_error in json_schema["properties"].keys():
        if param_error in str(self):
            return param_error
