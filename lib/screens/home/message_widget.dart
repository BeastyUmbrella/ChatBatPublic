import 'package:chatbat/models/message.dart';
import 'package:chatbat/screens/home/profile_image.dart';
import 'package:chatbat/shared/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatefulWidget {
  final Message message;
  final bool isCurrentUser;
  final String userID;

  MessageWidget({this.message, this.userID, this.isCurrentUser});

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool _visible = false;

  void toggleVisible() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final radius = Radius.circular(16);
    final borderRadius = BorderRadius.all(radius);
    Widget buildMessage() => Column(
          crossAxisAlignment: widget.isCurrentUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            themeProvider.isDarkMode
                ? (widget.message.isImage
                    ? Image.network(widget.message.imageURL, fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      })
                    : Text(
                        widget.message.message,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.start,
                      ))
                : (widget.message.isImage
                    ? Image.network(widget.message.imageURL, fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      })
                    : Text(
                        widget.message.message,
                        style: TextStyle(
                            color: widget.isCurrentUser
                                ? Colors.white
                                : Theme.of(context).splashColor),
                        textAlign: TextAlign.start,
                      )),
          ],
        );

    String convertTimeStampToString(Timestamp t) {
      int timeInMillis = t.millisecondsSinceEpoch;
      return DateFormat('dd-MM-yy - HH:mm')
          .format(DateTime.fromMillisecondsSinceEpoch(timeInMillis))
          .toString();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: widget.isCurrentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: <Widget>[
            if (!widget.isCurrentUser)
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  ProfileImage(
                    userID: widget.userID,
                    size: 30,
                  )
                ],
              ),
            GestureDetector(
              onTap: () {
                toggleVisible();
              },
              child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.fromLTRB(8, 2, 8, 0),
                constraints: BoxConstraints(
                  maxWidth: 280,
                ),
                decoration: BoxDecoration(
                  color: widget.isCurrentUser
                      ? Theme.of(context).accentColor
                      : Theme.of(context).canvasColor,
                  borderRadius: widget.isCurrentUser
                      ? borderRadius
                          .subtract(BorderRadius.only(bottomRight: radius))
                      : borderRadius
                          .subtract(BorderRadius.only(bottomLeft: radius)),
                ),
                child: buildMessage(),
              ),
            ),
          ],
        ),
        Visibility(
          visible: _visible,
          maintainAnimation: true,
          maintainState: true,
          child: Row(
            mainAxisAlignment: widget.isCurrentUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 50,
              ),
              Text(convertTimeStampToString(widget.message.timestamp),
                  style: TextStyle(
                      color: Theme.of(context).splashColor, fontSize: 12)),
              SizedBox(
                width: 10,
              )
            ],
          ),
        )
      ],
    );
  }
}
