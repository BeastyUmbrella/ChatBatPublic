import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmailWidget extends StatelessWidget {
  final String userID;
  final bool showDisplayText;

  EmailWidget({this.showDisplayText, this.userID});

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
          return Text(userDocument["email"],
              style: Theme.of(context).textTheme.bodyText1);
        });
  }
}
