import 'package:chatbat/screens/authenticate/register.dart';
import 'package:chatbat/screens/authenticate/sign_in.dart';
import "package:flutter/material.dart";

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  //One screen will be "Searching for Bats to chat with..." that has a pulsating animation for Sonar
  //Other screen will be the chat screen that allows the two connected users to chat the boolean will be responsible for switching
  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return Container(
        child: SignIn(toggleView: toggleView),
      );
    } else {
      return Container(
        child: Register(toggleView: toggleView),
      );
    }
  }
}
