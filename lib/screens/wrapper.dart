import 'package:chatbat/models/preferences.dart';
import 'package:chatbat/models/user.dart';
import 'package:chatbat/screens/home/home.dart';
import 'package:chatbat/screens/home/onboarding_screen.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'authenticate/authenticate.dart';

// class Wrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<User>(context);


//     //return either home or authenticate widget
//     if (user == null) {
//       return Authenticate();
//     } else {
//       if (Preferences.getOnboardingStatus() != null){
//         return Home();
//       } else {
//         Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
//       }
//     }
//   }
// }

class Wrapper extends StatefulWidget {
  bool onboardingStatus = Preferences.getOnboardingStatus();
  
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  void setOnboardingStatusToTrue(){
    setState(() {
      widget.onboardingStatus = true;
    });
  }
  
  void setOnboardingStatusToFalse(){
    setState(() {
      widget.onboardingStatus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    
    if (user == null) {
      return Authenticate();
    } else {
      return Center(
        child: AnimatedCrossFade(
          firstChild: Home(function: setOnboardingStatusToFalse), secondChild: OnboardingScreen(function: setOnboardingStatusToTrue), crossFadeState: (widget.onboardingStatus && widget.onboardingStatus != null)? CrossFadeState.showFirst : CrossFadeState.showSecond, duration: Duration(milliseconds: 250)));
      // if (widget.onboardingStatus == true && widget.onboardingStatus != null) {
      //   return Home(function: setOnboardingStatusToFalse);
      // } else {
      //   return OnboardingScreen(function: setOnboardingStatusToTrue);
      // }
    }
  }
}