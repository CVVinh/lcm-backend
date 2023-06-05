from sqlalchemy.sql import func
from chalicelib.models.models import AssetSetAsset
from chalicelib.models import session
from chalicelib.utils.utils import add_update_object
from chalicelib.messages import MessageResponse

message_asset_set_asset_constant = MessageResponse()
message_asset_set_asset_constant.setName("Asset Set Asset")


def add_asset_set_asset(asset_set_asset_obj):
    """
    Create request and add record for asset set asset.

    Argument:
        asset_set_asset_obj: request body
    Returns:
        The message.
    """
    create_asset_set_asset = AssetSetAsset()
    session.add(add_update_object(asset_set_asset_obj, create_asset_set_asset))
    session.commit()
    return (True, message_asset_set_asset_constant.MESSAGE_SUCCESS_CREATED)


def delete_asset_set_asset(query_params):
    """
    Delete 1 record for asset set asset by id.

    Argument:
        query_params: parameter
    Returns:
        The message.
    """
    asset_id = query_params.get("assetId")
    # If AssetSetAsset dose not exists, return a message
    if (
        delete_to_asset_set_asset := session.query(AssetSetAsset)
        .filter(
            AssetSetAsset.assetId == asset_id
        )
        .first()
    ):
        session.delete(delete_to_asset_set_asset)
        session.commit()
        return (True, message_asset_set_asset_constant.MESSAGE_SUCCESS_DELETED)
    return (False, message_asset_set_asset_constant.MESSAGE_ERROR_NOT_EXIST)
