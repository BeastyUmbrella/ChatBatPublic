import 'package:chatbat/models/user.dart';
import 'package:chatbat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ProfilePictureSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: DatabaseService().getSearching(user.uid),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center();
          default:
            if (snapshot.data.exists) {
              return SpinKitRipple(
                color: Theme.of(context).accentColor,
                size: 100.0,
              );
            } else {
              return Center();
            }
        }
      },
    );
  }
}
