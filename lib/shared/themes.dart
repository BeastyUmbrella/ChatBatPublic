import 'package:chatbat/models/preferences.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = Preferences.parseThemeMode(Preferences.getThemeMode());

  bool get isDarkMode => themeMode == ThemeMode.dark;
  bool get isLightMode => themeMode == ThemeMode.light;

  void toggleTheme(ThemeMode mode) {
    Preferences.setThemeMode(mode);
    themeMode = mode;
    notifyListeners();
  }
}

const LargeTextSize = 26.0;
const MediumTextSize = 20.0;
const BodyTextSize = 16.0;

const String FontNameDefault = 'Montserrat';

class Themes {
  // static final darkTheme = ThemeData(
  //   primaryColor: Colors.grey[900],
  //   accentColor: Colors.red[600],
  //   scaffoldBackgroundColor: Color(0xFF121212),
  //   iconTheme: IconThemeData(color: Colors.white),
  //   splashColor: Colors.white,
  //   dividerColor: Colors.white,
  //   highlightColor: Colors.black,
  //   primaryColorLight: Colors.white,
  //   canvasColor: Colors.grey[800],
  //   textTheme: TextTheme(
  //     headline1: TextStyle(
  //         color: Colors.white,
  //         fontSize: 20,
  //         fontWeight: FontWeight.normal,
  //         letterSpacing: 0),
  //     headline2: TextStyle(color: Colors.white),
  //     headline3: TextStyle(
  //         color: Colors.white,
  //         fontSize: 60,
  //         fontWeight: FontWeight.normal,
  //         letterSpacing: -0.5),
  //     headline4: TextStyle(color: Colors.white),
  //     headline5: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
  //     headline6: TextStyle(color: Colors.white),
  //     subtitle1: TextStyle(
  //         color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
  //     subtitle2: TextStyle(
  //         color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
  //     bodyText1: TextStyle(
  //         color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
  //     bodyText2: TextStyle(
  //         color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
  //     caption: TextStyle(color: Colors.white54, fontSize: 16),
  //     button: TextStyle(color: Colors.white),
  //     overline: TextStyle(
  //         color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
  //   ),
  // );

  // static final lightTheme = ThemeData(
  //   primaryColor: Colors.grey[300],
  //   accentColor: Colors.red[600],
  //   scaffoldBackgroundColor: Colors.white,
  //   iconTheme: IconThemeData(color: Colors.white),
  //   splashColor: Colors.black,
  //   dividerColor: Colors.grey[300],
  //   highlightColor: Colors.white,
  //   primaryColorLight: Colors.white,
  //   canvasColor: Colors.grey[300],
  //   textTheme: TextTheme(
  //     headline1: TextStyle(
  //         color: Colors.black,
  //         fontSize: 20,
  //         fontWeight: FontWeight.normal,
  //         letterSpacing: 0),
  //     headline2: TextStyle(color: Colors.white),
  //     headline3: TextStyle(color: Colors.black),
  //     headline4: TextStyle(color: Colors.black),
  //     headline5: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
  //     headline6: TextStyle(color: Colors.white),
  //     subtitle1: TextStyle(
  //         color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
  //     subtitle2: TextStyle(
  //         color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
  //     bodyText1: TextStyle(
  //         color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
  //     bodyText2: TextStyle(
  //         color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
  //     caption: TextStyle(color: Colors.black54, fontSize: 16),
  //     button: TextStyle(color: Colors.white),
  //     overline: TextStyle(
  //         color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
  //   ),
  // );
  static final darkTheme = ThemeData(
      primaryColor: Color(0xff581899),
      accentColor: Color(0xffee4266),
      // accentColor: Color(0xffC90187),
      // primaryColor: Colors.cyan[800],
      primaryColorLight: Color(0xff8a48cb),
      primaryColorDark: Color(0xFF23006a),
      // accentColor: Color(0xFFec407a),
      primaryColorBrightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      scaffoldBackgroundColor: Color(0xFF121212),
      splashColor: Colors.white,
      canvasColor: Colors.white10,
      applyElevationOverlayColor: true,
      colorScheme: ColorScheme.dark(
        onSurface: Color(0xFF1D1D1D),
        surface: Color(0xFF1D1D1D),
        primaryVariant: Color(0xFF1D1D1D),
        onPrimary: Color(0xFF1D1D1D),
      ),
      // cardColor: Color(0xFF1D1D1D),
      cardTheme:
          CardTheme(shadowColor: Colors.white24, color: Color(0xFF2E2E2E)),
      bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Color(0xFF1D1D1D).withOpacity(1)),
      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
            fontWeight: FontWeight.w300, fontSize: 96, color: Colors.white),
        headline2: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 60, color: Colors.white),
        headline3: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 48, color: Colors.white),
        headline4: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 34, color: Colors.white),
        headline5: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white),
        headline6: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
        subtitle1: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        subtitle2: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),
        bodyText1: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 16, color: Colors.white),
        bodyText2: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white54),
        button: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),
        caption: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        overline: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.white,
            letterSpacing: 0,
            wordSpacing: 0),
      
       
      )
    );

  static final lightTheme = ThemeData(
    primaryColor: Color(0xff581899),
    accentColor: Color(0xffee4266),
    // primaryColor: Colors.red[600],
    // accentColor: Colors.red[400],
    // primaryColor: Colors.cyan[800],
    primaryColorLight: Color(0xff8a48cb),
    primaryColorDark: Color(0xFF23006a),
    // accentColor: Color(0xFFec407a),
    primaryColorBrightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFFE4E6EB),
    splashColor: Colors.black,
    canvasColor: Colors.white60,
    highlightColor: Colors.white,

    textTheme: TextTheme(
      headline1: TextStyle(
          fontWeight: FontWeight.w300, fontSize: 96, color: Colors.black),
      headline2: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 60, color: Colors.black),
      headline3: TextStyle(
          fontWeight: FontWeight.normal, fontSize: 48, color: Colors.black),
      headline4: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 34, color: Colors.black),
      headline5: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 24, color: Colors.black),
      headline6: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
      subtitle1: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black),
      subtitle2: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black),
      bodyText1: TextStyle(
          fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
      bodyText2: TextStyle(
          fontWeight: FontWeight.normal, fontSize: 14, color: Colors.black54),
      button: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),
      caption: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black),
      overline: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.black,
          letterSpacing: 0,
          wordSpacing: 0),
    ),

    cardColor: Colors.white,
    // cardTheme: CardTheme(
    //   shadowColor: Colors.black
    // ),

    iconTheme: IconThemeData(
      color: Colors.white,
    ),

    bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.white.withOpacity(1)),
  );
}
