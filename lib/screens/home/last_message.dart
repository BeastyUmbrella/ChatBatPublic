import 'package:chatbat/models/message.dart';
import 'package:chatbat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastMessage extends StatelessWidget {
  final String currentUserID;
  final String userID;

  LastMessage({this.currentUserID, this.userID});

  @override
  Widget build(BuildContext context) {
    String convertTimeStampToString(Timestamp t) {
      DateTime now = DateTime.now();
      DateTime messageDateTime = t.toDate();

      String format = 'dd-MM-yy - HH:mm';

      if (now.day == messageDateTime.day) {
        format = 'HH:mm';
      } else {
        format = 'MMM dd - yy';
      }
      return DateFormat(format).format(messageDateTime).toString();
    }

    return StreamBuilder<List<Message>>(
        stream: DatabaseService(uid: currentUserID).getMessages(userID),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text("");
            default:
              final messages = snapshot.data;
              if (messages.length == 0) {
                return Text('Say hi to your newly found bat!',
                    style: Theme.of(context).textTheme.overline);
              }
              if (messages.first.uid == currentUserID && messages != null) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        child: Text(
                          'You: ' + messages.first.message,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        convertTimeStampToString(messages.first.timestamp),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                );
              } else {
                return StreamBuilder<DocumentSnapshot>(
                  stream: DatabaseService(uid: currentUserID).getIsSeen(userID),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                              child: Container(
                                  child: Text(
                            messages.first.message,
                            style: snapshot.data['isSeen']
                                ? Theme.of(context).textTheme.bodyText2
                                : Theme.of(context).textTheme.overline,
                            overflow: TextOverflow.ellipsis,
                          ))),
                          Container(
                              child: Text(
                                  convertTimeStampToString(
                                      messages.first.timestamp),
                                  style: snapshot.data['isSeen']
                                      ? Theme.of(context).textTheme.bodyText2
                                      : Theme.of(context).textTheme.overline))
                        ],
                      );
                    } else {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Container(
                                    child: Text(
                              messages.first.message,
                              style: Theme.of(context).textTheme.overline,
                              overflow: TextOverflow.ellipsis,
                            ))),
                            Container(
                                child: Text(
                                    convertTimeStampToString(
                                        messages.first.timestamp),
                                    style:
                                        Theme.of(context).textTheme.overline))
                          ]);
                    }
                  },
                );
              }
          }
        });
  }
}
