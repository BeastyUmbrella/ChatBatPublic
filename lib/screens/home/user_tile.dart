import 'package:chatbat/models/user.dart';
import 'package:chatbat/screens/home/displayname.dart';
import 'package:chatbat/screens/home/last_message.dart';
import 'package:chatbat/screens/home/profile_image.dart';
import 'package:chatbat/services/database.dart';
import 'package:flutter/material.dart';

import 'chat_header.dart';

class UserTile extends StatelessWidget {
  final User currentUser;
  final User user;
  UserTile({this.currentUser, this.user});

  @override
  Widget build(BuildContext context) {
    final DatabaseService _databaseService =
        DatabaseService(uid: currentUser.uid);

    return Card(
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        child: ListTile(
          trailing: PopupMenuButton(
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      child: GestureDetector(
                    child: Row(
                      children: [
                        Text("Delete"),
                        SizedBox(width: 10),
                        Icon(
                          Icons.close,
                          color: Colors.red,
                        )
                      ],
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await _databaseService.deleteChat(user.uid);
                    },
                  )),
                  PopupMenuItem(
                      child: GestureDetector(
                    child: Row(
                      children: [
                        Text("Block"),
                        SizedBox(width: 10),
                        Icon(
                          Icons.block,
                          color: Colors.red,
                        )
                      ],
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await _databaseService.blockUser(user.uid);
                    },
                  )),
                ];
              }),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatHeader(
                          currentUser: currentUser,
                          user: user,
                        )));
          },
          title: DisplayName(
            userID: user.uid,
            isProfileSection: false,
            isChatHeader: false,
          ),
          subtitle: LastMessage(
            currentUserID: currentUser.uid,
            userID: user.uid,
          ),
          leading: Transform.scale(
              scale: 1.2,
              child: ProfileImage(
                size: 50,
                userID: user.uid,
              )),
        ),
      ),
    );
  }
}
