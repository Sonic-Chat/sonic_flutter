enum ChatError {
  ILLEGAL_ACTION,
  MESSAGE_MISSING,
  IMAGE_MISSING,
  CHAT_UID_ILLEGAL,
  NOT_FRIENDS,
}

String chatErrorStrings(ChatError error) {
  switch (error) {
    case ChatError.ILLEGAL_ACTION:
      {
        return 'You are not allowed to do that.';
      }
    case ChatError.MESSAGE_MISSING:
      {
        return 'Text message is missing.';
      }
    case ChatError.IMAGE_MISSING:
      {
        return 'Image is missing.';
      }
    case ChatError.CHAT_UID_ILLEGAL:
      {
        return 'Wrong chat used for the action.';
      }
    case ChatError.NOT_FRIENDS:
      {
        return 'You are not friends with this person.';
      }
    default:
      {
        return 'Something went wrong, please try again later.';
      }
  }
}
