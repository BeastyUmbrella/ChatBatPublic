import 'package:chatbat/models/user.dart';
import 'package:chatbat/screens/home/displayname.dart';
import 'package:chatbat/screens/home/profile_image.dart';
import 'package:chatbat/services/database.dart';
import 'package:flutter/material.dart';

import 'messages_widget.dart';

class ChatHeader extends StatefulWidget {
  final User currentUser;
  final User user;

  ChatHeader({this.currentUser, this.user});

  @override
  _ChatHeaderState createState() => _ChatHeaderState();
}

class _ChatHeaderState extends State<ChatHeader> {
  @override
  Widget build(BuildContext context) {
    final DatabaseService _databaseService =
        DatabaseService(uid: widget.currentUser.uid);

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        leading: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await _databaseService.setIsSeen(widget.user.uid, true);
                  Navigator.pop(context);
                }),
          ],
        ),
        title: Row(
          children: [
            ProfileImage(
              userID: widget.user.uid,
              size: 50,
            ),
            SizedBox(
              width: 20,
            ),
            DisplayName(
              userID: widget.user.uid,
              isProfileSection: false,
              isChatHeader: true,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: MessagesWidget(
        receiver: widget.user.uid,
      ),
    );
  }
}
