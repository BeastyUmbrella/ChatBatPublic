import 'package:chatbat/models/user.dart';
import 'package:chatbat/screens/home/profile_image.dart';
import 'package:chatbat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LogoSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: DatabaseService().getSearching(user.uid),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
                child: ProfileImage(
              userID: user.uid,
              size: 30,
            ));
          default:
            if (snapshot.data.exists) {
              return Stack(
                children: <Widget>[
                  Center(
                    child: Transform.scale(
                      scale: 1.5,
                      child: SpinKitRipple(
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                  Center(
                    child: ProfileImage(
                      userID: user.uid,
                      size: 30,
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                  child: ProfileImage(
                userID: user.uid,
                size: 30,
              ));
            }
        }
      },
    );
  }
}
