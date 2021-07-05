import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences _preferences;

  static const _keyThemeMode = 'themeMode';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setThemeMode(ThemeMode mode) async {
    await _preferences.setString(_keyThemeMode, mode.toString());
  }

  static getThemeMode() {
    return _preferences.getString(_keyThemeMode);
  }

  static Future setCurrentRange(String currentRange) async {
    await _preferences.setString("currentRange", currentRange);
  }

  static getCurrentRange(){
    return _preferences.getString("currentRange");
  }

  static Future setOnboardingStatus(bool value) async {
    await _preferences.setBool("onBoarding", value);
  }

  static getOnboardingStatus(){
    return _preferences.getBool("onBoarding");
  }

  static ThemeMode parseThemeMode(String themeMode) {
    if (themeMode == ThemeMode.dark.toString()) {
      return ThemeMode.dark;
    } else if (themeMode == ThemeMode.light.toString()) {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }
}
