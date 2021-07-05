import 'package:chatbat/models/message.dart';
import 'package:chatbat/models/user.dart';
import 'package:chatbat/screens/home/say_hi.dart';
import 'package:chatbat/services/database.dart';
import 'package:chatbat/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'message_widget.dart';
import 'new_message.dart';

class MessagesWidget extends StatefulWidget {
  final String receiver;
  MessagesWidget({@required this.receiver});

  @override
  _MessagesWidgetState createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  Tween<Offset> _offset = Tween(begin: Offset(1, 1), end: Offset(0, 0));
  Stream<List<Message>> stream;
  List<Message> currentMessageList = [];
  User user;

  @override
  void initState() {
    super.initState();

    user = Provider.of<User>(context, listen: false);

    stream = DatabaseService(uid: user.uid).getMessages(widget.receiver);

    stream.listen((newMessages) {
      final List<Message> messageList = newMessages;
      if (_listKey.currentState != null &&
          _listKey.currentState.widget.initialItemCount < messageList.length) {
        List<Message> updateList = (messageList
            .where((e) => !currentMessageList.contains(e))
            .toList());

        for (var update in updateList) {
          final int updateIndex = messageList.indexOf(update);
          _listKey.currentState.insertItem(updateIndex);
        }
      }

      currentMessageList = messageList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<Message>>(
                stream: stream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Loading();
                    default:
                      final messages = snapshot.data;
                      return messages.isEmpty
                          ? SayHi(
                              userID: widget.receiver,
                            )
                          : AnimatedList(
                              key: _listKey,
                              physics: BouncingScrollPhysics(),
                              reverse: true,
                              initialItemCount: messages.length,
                              itemBuilder: (context, index, animation) {
                                return SlideTransition(
                                  position: animation.drive(_offset),
                                  child: MessageWidget(
                                    message: messages[index],
                                    userID: widget.receiver,
                                    isCurrentUser:
                                        messages[index].uid == user.uid,
                                  ),
                                );
                              },
                            );
                  }
                }),
          ),
          SizedBox(
            height: 10,
          ),
          NewMessage(
            receiver: widget.receiver,
          )
        ],
      ),
    );
  }
}
