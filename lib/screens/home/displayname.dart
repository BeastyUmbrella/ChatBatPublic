import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayName extends StatelessWidget {
  final String userID;
  final bool isProfileSection;
  final bool isChatHeader;

  DisplayName({this.userID, this.isProfileSection, this.isChatHeader});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text("Something went wrong...");
          }
          var userDocument = snapshot.data;
          if (isProfileSection) {
            return Text(userDocument["displayName"],
                style: Theme.of(context).textTheme.headline4);
          } else {
            if (isChatHeader) {
              return Text(userDocument["displayName"],
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.white));
            }
            return Text(userDocument["displayName"],
                style: Theme.of(context).textTheme.headline6);
          }
        });
  }
}
