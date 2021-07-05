import 'package:chatbat/models/user.dart';
import 'package:chatbat/screens/home/chat_header.dart';
import 'package:chatbat/screens/home/messages_widget.dart';
import 'package:chatbat/screens/home/user_tile.dart';
import 'package:chatbat/services/database.dart';
import 'package:chatbat/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool chatTapped = false;
  String tappedChatUID;
  final GlobalKey<AnimatedListState> _chatListKey = GlobalKey<AnimatedListState>();
  Tween<Offset> _offset = Tween(begin: Offset(1, 1), end: Offset(0, 0));
  Stream<List<User>> stream;
  List<User> currentChatList = [];
  User user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);

    stream = DatabaseService(uid: user.uid).getchattingWith(user.uid);
    stream.listen((changeInChatList) {
      final List<User> chatList = changeInChatList;
      if (_chatListKey.currentState != null &&
          _chatListKey.currentState.widget.initialItemCount < chatList.length) {
        List<User> updatedChatList =
            (chatList.where((e) => !currentChatList.contains(e)).toList());
        for (var update in updatedChatList) {
          final int updateIndex = chatList.indexOf(update);
          _chatListKey.currentState.insertItem(updateIndex);
        }
      }

      currentChatList = chatList;
    });
  }

  void setChatTapped(bool value) {
    setState(() {
      chatTapped = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (chatTapped) {
      return MessagesWidget(receiver: tappedChatUID);
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<User>>(
                  stream: stream,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Loading();
                      default:
                        final userList = snapshot.data;

                        return userList.isEmpty
                            ? Container()
                            : AnimatedList(
                                key: _chatListKey,
                                physics: BouncingScrollPhysics(),
                                initialItemCount: userList.length,
                                itemBuilder: (context, index, animation) {
                                  return SlideTransition(
                                    position: animation.drive(_offset),
                                    child: GestureDetector(
                                        child: UserTile(
                                      currentUser: user,
                                      user: userList[index],
                                    )),
                                  );
                                },
                              );
                    }
                  }),
            ),
          ],
        ),
      );
    }
  }
}
