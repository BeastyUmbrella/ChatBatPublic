import 'package:chatbat/models/preferences.dart';
import 'package:chatbat/models/user.dart';
import 'package:chatbat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  final Function function;

  OnboardingScreen({Key key, this.function}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF7B51D3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final databaseService = DatabaseService(uid: user.uid);

    return Scaffold(
      body: Container(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.01, 0.2, 0.6, 0.9],
                colors: [
                  // Color(0xFF3594DD),
                  // Color(0xFF4563DB),
                  // Color(0xFF5036D5),
                  // Color(0xFF5B16D0),
                  // Color(0xffE80088),
                  Color(0xffA7006F),
                  Color(0xffA7006F),
                  Color(0xff5A0052),
                  Color(0xFF22003D),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 100, 0, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: 1.0,
                        child: Text("Welcome to ChatBat",
                            style: TextStyle(
                            fontWeight: FontWeight.w500, 
                            fontSize: 36,
                            // fontStyle: FontStyle.italic,
                            color: Colors.white)
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Image(
                      image: AssetImage(
                        'assets/splashscreen.png',
                      ),
                      height: 250.0,
                      width: 250,
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      physics: BouncingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(flex: 1, child: Container(),),
                            Expanded(
                                flex: 8,
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                        radius: 16,
                                        child: IconTheme(
                                            data: Theme.of(context).iconTheme,
                                            child: Icon(Icons.data_usage)),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Set searching range",
                                        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                      "The searching range determines the search radius for locating new bats to chat with.",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white))
                                ],
                              ),
                            ),
                            Expanded(flex: 1, child: Container()),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(flex: 1, child: Container(),),
                            Expanded(
                                flex: 8,
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                        radius: 16,
                                        child: IconTheme(
                                            data: Theme.of(context).iconTheme,
                                            child: Icon(Icons.wifi_tethering)),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Start searching for bats",
                                        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                      "If two bats are within each others searching radius they will match.",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white))
                                ],
                              ),
                            ),
                            Expanded(flex: 1, child: Container()),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(flex: 1, child: Container(),),
                            Expanded(
                                flex: 8,
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                        radius: 16,
                                        child: IconTheme(
                                            data: Theme.of(context).iconTheme,
                                            child: Icon(Icons.notifications)),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Get notified of match",
                                        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                      "If two bats are within each others searching radius they will match.",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white))
                                ],
                              ),
                            ),
                            Expanded(flex: 1, child: Container()),
                          ],
                        ),
                        Center(
                          child: Transform.scale(
                            scale: 1.6,
                            child: ElevatedButton(
                                onPressed: () async{
                                  await Preferences.setOnboardingStatus(true);
                                  widget.function();
                                },
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text("Start Chatting",
                                        style:
                                            Theme.of(context).textTheme.button,
                                        textAlign: TextAlign.start),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    IconTheme(
                                          data: Theme.of(context).iconTheme,
                                          child: Icon(Icons.play_arrow_rounded))
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                  primary: Theme.of(context).accentColor,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: _currentPage != 0,
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onPressed: () {
                              _pageController.previousPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            }),
                      ),
                      Visibility(
                        visible: _currentPage != _numPages - 1,
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            }),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
