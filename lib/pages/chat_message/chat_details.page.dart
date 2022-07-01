import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/enum/chat_type.enum.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/models/chat/chat.model.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/widgets/common/profile_picture.widget.dart';
import 'package:sonic_flutter/widgets/user_account/user_details.widget.dart';

class ChatDetails extends StatelessWidget {
  static const route = "/group-details";

  const ChatDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Chat chat = ModalRoute.of(context)!.settings.arguments as Chat;
    Account loggedInAccount =
        Provider.of<AccountProvider>(context, listen: false).getAccount()!;

    return Scaffold(
      appBar: AppBar(
        title: chat.type == ChatType.GROUP
            ? const Text("Group Details")
            : const Text("Friend Details"),
      ),
      body: chat.type == ChatType.GROUP
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {},
                      child: ProfilePicture(
                        imageUrl: chat.imageUrl,
                        size: MediaQuery.of(context).size.width * 0.4,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        chat.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: Colors.black,
                            ),
                      ),
                      const Icon(
                        Icons.edit,
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Text(
                      'Participants',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: chat.participants.length,
                    itemBuilder: (BuildContext context, int index) {
                      Account participant = chat.participants[index];

                      return ListTile(
                        leading: ProfilePicture(
                          imageUrl: participant.imageUrl,
                          size: MediaQuery.of(context).size.width * 0.1,
                        ),
                        title: Text(
                          participant.fullName,
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Leave Group'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Delete Group',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          : UserDetails(
              account: chat.participants
                  .where((element) => element.id != loggedInAccount.id)
                  .first,
            ),
    );
  }
}
