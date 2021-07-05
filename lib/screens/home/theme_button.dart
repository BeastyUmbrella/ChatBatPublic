import 'package:chatbat/shared/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return themeProvider.isDarkMode || themeProvider.isLightMode
        ? Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                child: Column(children: [
                  Text(
                    'App Theme',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            themeProvider.isLightMode
                                ? themeProvider.toggleTheme(ThemeMode.system)
                                : themeProvider.toggleTheme(ThemeMode.light);
                          },
                          child: Container(
                              decoration: themeProvider.isLightMode
                                  ? BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      border: Border.all(
                                          color: Theme.of(context).accentColor,
                                          width: 2))
                                  : BoxDecoration(),
                              width: 70,
                              height: 70,
                              child: Transform.scale(
                                  scale: 2,
                                  child: Icon(
                                    CupertinoIcons.sun_max_fill,
                                    color: Colors.yellow[700],
                                  )))),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () async {
                            themeProvider.isDarkMode
                                ? themeProvider.toggleTheme(ThemeMode.system)
                                : themeProvider.toggleTheme(ThemeMode.dark);
                          },
                          child: Container(
                              decoration: themeProvider.isDarkMode
                                  ? BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      border: Border.all(
                                          color: Theme.of(context).accentColor,
                                          width: 2))
                                  : BoxDecoration(),
                              width: 70,
                              height: 70,
                              child: Transform.scale(
                                  scale: 2,
                                  child: Icon(
                                    CupertinoIcons.moon_stars_fill,
                                    color: Colors.indigo[400],
                                  )))),
                    ],
                  )
                ]),
              ),
            ),
          )
        : Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                child: Column(children: [
                  Text(
                    'App Theme',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            themeProvider.isLightMode
                                ? themeProvider.toggleTheme(ThemeMode.system)
                                : themeProvider.toggleTheme(ThemeMode.light);
                          },
                          child: Container(
                              decoration: themeProvider.isLightMode
                                  ? BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      border: Border.all(
                                          color: Theme.of(context).accentColor,
                                          width: 2))
                                  : BoxDecoration(),
                              width: 70,
                              height: 70,
                              child: Transform.scale(
                                  scale: 2,
                                  child: Icon(
                                    CupertinoIcons.sun_max_fill,
                                    color: Colors.yellow[700],
                                  )))),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () async {
                            themeProvider.isDarkMode
                                ? themeProvider.toggleTheme(ThemeMode.system)
                                : themeProvider.toggleTheme(ThemeMode.dark);
                          },
                          child: Container(
                              decoration: themeProvider.isDarkMode
                                  ? BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      border: Border.all(
                                          color: Theme.of(context).accentColor,
                                          width: 2))
                                  : BoxDecoration(),
                              width: 70,
                              height: 70,
                              child: Transform.scale(
                                  scale: 2,
                                  child: Icon(
                                    CupertinoIcons.moon_stars_fill,
                                    color: Colors.indigo[400],
                                  )))),
                    ],
                  )
                ]),
              ),
            ),
          );
  }
}

//Shadow decoration
//decoration: BoxDecoration(
//   color: Colors.grey[700],
//   borderRadius: BorderRadius.all(Radius.circular(16)),
//   boxShadow: [
//     BoxShadow(
//       color: Colors.black.withOpacity(0.5),
//       spreadRadius: 2,
//       blurRadius: 3,
//       offset: Offset(3,4)
//     )
//   ]
// ),
