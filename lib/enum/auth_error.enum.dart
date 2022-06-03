enum AuthError {
  ACCOUNT_ALREADY_EXISTS_FOR_EMAIL,
  ACCOUNT_ALREADY_EXISTS_FOR_USERNAME,
  ACCOUNT_DOES_NOT_EXIST,
  WRONG_PASSWORD,
  UNAUTHENTICATED,
}

String authErrorStrings(AuthError error) {
  switch (error) {
    case AuthError.ACCOUNT_ALREADY_EXISTS_FOR_EMAIL:
      {
        return 'An account with that email address already exists.';
      }
    case AuthError.ACCOUNT_ALREADY_EXISTS_FOR_USERNAME:
      {
        return 'An account with that username already exists.';
      }
    case AuthError.ACCOUNT_DOES_NOT_EXIST:
      {
        return 'Account does not exist.';
      }
    case AuthError.WRONG_PASSWORD:
      {
        return 'Wrong Password Given.';
      }
    case AuthError.UNAUTHENTICATED:
      {
        return 'You are not authenticated.';
      }
    default:
      {
        return 'Something went wrong, please try again later.';
      }
  }
}
