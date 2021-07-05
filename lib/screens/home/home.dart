import 'dart:io';
import 'package:chatbat/main.dart';
import 'package:chatbat/models/preferences.dart';
import 'package:chatbat/models/user.dart';
import 'package:chatbat/screens/home/profile_search.dart';
import 'package:chatbat/screens/home/profile.dart';
import 'package:chatbat/screens/home/user_tile.dart';
import 'package:chatbat/services/database.dart';
import 'package:chatbat/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:widget_arrows/arrows.dart';
import 'package:widget_arrows/widget_arrows.dart';
import 'messages_widget.dart';

class Home extends StatefulWidget {
  final Function function;

  const Home({Key key, this.function}) : super(key: key);


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  bool chatTapped = false;
  String tappedChatUID;

  void setChatTapped(bool value) {
    setState(() {
      chatTapped = value;
    });
  }

  void setLoading(bool value) {
    setState(() {});
  }

  //Saves the device token to the database for the current user
  _saveDeviceToken(User user) async {
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      var tokenRef = _db
          .collection('users')
          .doc(user.uid)
          .collection('tokens')
          .doc(fcmToken);

      await tokenRef.set({
        'token': fcmToken,
        'platform': Platform.operatingSystem,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  color: Colors.white,
                  playSound: true,
                  icon: '@drawable/chatbatnotification'),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final _database = DatabaseService(uid: user.uid);

    //Saves the token to the current users token collection
    _saveDeviceToken(user);

    return (this.mounted == false)
        ? Loading()
        : ArrowContainer(
            child: Scaffold(
              appBar: AppBar(
                title: Text("Chats"),
                elevation: 0.0,
                actions: <Widget>[
                  ArrowElement(
                    id: "profile",
                    child: Transform.scale(
                      scale: 1.6,
                      child: GestureDetector(
                          child: LogoSearch(),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile()));
                          }),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
              body: Center(
                child: chatTapped
                    ? MessagesWidget(receiver: tappedChatUID)
                    : Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(
                          children: <Widget>[
                            StreamBuilder<List<User>>(
                                stream: _database.getchattingWith(user.uid),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Loading();
                                    default:
                                      final userList = snapshot.data;

                                      return userList.isEmpty
                                          ? Center(
                                            child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 100, 5, 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    // SizedBox(
                                                    //   height: 20,
                                                    // ),
                                                    // Text(
                                                    //   'No Chats',
                                                    //   style: Theme.of(context)
                                                    //       .textTheme
                                                    //       .headline5,
                                                    // ),
                                                    // SizedBox(
                                                    //   height: 20,
                                                    // ),
                                                    Container(
                                                        width: 180.0,
                                                        height: 180.0,
                                                        decoration:
                                                            new BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                            width: 4,
                                                          ),
                                                          image:
                                                              new DecorationImage(
                                                            image: new ExactAssetImage(
                                                                'assets/splashscreen.png'),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        )
                                                      ),
                                                    SizedBox(
                                                      height: 40,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: ArrowElement(
                                                        id: 'arrow',
                                                        show: true,
                                                        targetId: "profile",
                                                        tipLength: 20,
                                                        width: 5,
                                                        bow: 0.31,
                                                        padStart: 30,
                                                        padEnd: 43,
                                                        arcDirection:
                                                            ArcDirection
                                                                .Right,
                                                        sourceAnchor:
                                                            Alignment.center,
                                                        targetAnchor:
                                                            Alignment(0, 0),
                                                        color:
                                                            Theme.of(context)
                                                                .accentColor,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                                "Search for bats to start chatting!",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline6),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          )
                                          : ListView.builder(
                                              physics:
                                                  BouncingScrollPhysics(),
                                              itemCount: userList.length,
                                              itemBuilder: (context, index) {
                                                return UserTile(
                                                  currentUser: user,
                                                  user: userList[index],
                                                );
                                              },
                                            );
                                  }
                                }),
                          ],
                        ),
                      ),
              ),
              floatingActionButton: FloatingActionButton(
                elevation: 0,
                backgroundColor: Theme.of(context).accentColor,
                onPressed: () async {
                  await Preferences.setOnboardingStatus(false);
                  widget.function();
                },
                child: IconTheme(
                  data: Theme.of(context).iconTheme,
                  child: Transform.scale(scale: 1.4,child: Icon(Icons.help_outline)))
              ),
            ),
          );
  }
}
