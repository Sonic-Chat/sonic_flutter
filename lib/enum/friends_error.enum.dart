enum FriendError {
  USER_NOT_FOUND,
  REQUEST_NOT_FOUND,
  REQUEST_ALREADY_EXISTS,
  ILLEGAL_ACTION,
}

String generalFriendStrings(FriendError error) {
  switch (error) {
    case FriendError.USER_NOT_FOUND:
      {
        return 'This account does not exist.';
      }
    case FriendError.REQUEST_NOT_FOUND:
      {
        return 'You are not friends with this account.';
      }
    case FriendError.REQUEST_ALREADY_EXISTS:
      {
        return 'Request already sent.';
      }
    case FriendError.ILLEGAL_ACTION:
      {
        return 'You are not allowed to do that.';
      }
    default:
      {
        return 'Something went wrong, please try again later.';
      }
  }
}
