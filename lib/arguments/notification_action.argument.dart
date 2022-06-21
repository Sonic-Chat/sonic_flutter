class NotificationAction {
  final String action;
  final String chatId;

  NotificationAction({
    required this.action,
    this.chatId = '',
  });

  @override
  String toString() {
    return 'NotificationAction{action: $action, chatId: $chatId}';
  }
}
