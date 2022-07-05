import 'package:sonic_flutter/models/account/account.model.dart';

class GroupChatParticipantsArgument {
  final List<Account> participants;

  GroupChatParticipantsArgument({
    required this.participants,
  });
}
