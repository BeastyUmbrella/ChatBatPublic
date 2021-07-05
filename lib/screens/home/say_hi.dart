import 'package:chatbat/screens/home/displayname.dart';
import 'package:chatbat/screens/home/profile_image.dart';
import 'package:flutter/material.dart';

class SayHi extends StatelessWidget {
  final String userID;

  const SayHi({this.userID});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileImage(
              userID: userID,
              size: 180,
            ),
            SizedBox(height: 20),
            DisplayName(
              userID: userID,
              isProfileSection: true,
              isChatHeader: false,
            ),
            SizedBox(height: 20),
            Text(
              "Say hi to your newly found bat!",
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
      ),
    );
  }
}
