enum GeneralError {
  SOMETHING_WENT_WRONG,
  OFFLINE,
  ILLEGAL_ACTION,
}

String generalErrorStrings(GeneralError error) {
  switch (error) {
    case GeneralError.SOMETHING_WENT_WRONG:
      {
        return 'Something went wrong, please try again later.';
      }
    case GeneralError.OFFLINE:
      {
        return 'You are offline.';
      }
    case GeneralError.ILLEGAL_ACTION:
      {
        return 'You are not allowed to do that.';
      }
    default:
      {
        return 'Something went wrong, please try again later.';
      }
  }
}
