from chalicelib.models.models import AccountMaster, AccountGroupMaster, GroupMaster
from chalicelib.models import session
from chalicelib.messages import MessageResponse

message_account_constant = MessageResponse()
message_account_constant.setName("Account Master")


def get_account_list(query_params):
    """
    Get all account list.

    Argument:
        query_params: parameter
    Returns:
        The message and a list.
    """
    # Query Column needs to get, join tables containing information to get
    query_list_account = session.query(AccountMaster.accountId, AccountMaster.accountName,
                                       GroupMaster.groupId, GroupMaster.groupName).join(
        AccountGroupMaster, AccountGroupMaster.accountId == AccountMaster.accountId, isouter=True).join(
        GroupMaster, AccountGroupMaster.groupId == GroupMaster.groupId, isouter=True).filter(
        AccountMaster.isDeleted == 0)

    # Create loop of lists account, assign it to an object and then assign to a new list.
    result_list = [{**account} for account in query_list_account.all()]
    return (True, {"mstAccount": result_list,
                   "message": message_account_constant.MESSAGE_SUCCESS_GET_LIST,
                   "status": 200
                   })
