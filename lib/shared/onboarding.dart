import 'package:chatbat/models/preferences.dart';
import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  bool onboardingStatus = Preferences.getOnboardingStatus();

  void setOnboardingStatus(bool status) async{
    await Preferences.setOnboardingStatus(status);
    onboardingStatus = status;
    notifyListeners();
  }

  getOnboardingStatus(){
    return onboardingStatus;
  }
}