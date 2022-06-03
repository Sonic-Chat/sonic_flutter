enum GeneralError {
  SOMETHING_WENT_WRONG,
  OFFLINE,
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
    default:
      {
        return 'Something went wrong, please try again later.';
      }
  }
}
