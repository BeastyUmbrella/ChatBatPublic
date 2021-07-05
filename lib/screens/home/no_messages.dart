import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NoMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(16);
    final borderRadius = BorderRadius.all(radius);
    return Opacity(
      opacity: 0.5,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: Center(
                        child: Text(
                      "Hello",
                      style: Theme.of(context).textTheme.headline2,
                    )),
                    height: 80,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: borderRadius
                            .subtract(BorderRadius.only(bottomRight: radius))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Center(
                        child: Text(
                      "Hey",
                      style: Theme.of(context).textTheme.headline3,
                    )),
                    height: 80,
                    width: 160,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: borderRadius
                            .subtract(BorderRadius.only(bottomLeft: radius))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: Center(
                      child: SpinKitThreeBounce(
                        color: Colors.white,
                      ),
                    ),
                    height: 80,
                    width: 140,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: borderRadius
                            .subtract(BorderRadius.only(bottomRight: radius))),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                  'Start the chat by sending a message to your newly found Bat!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle2)
            ],
          ),
        ),
      ),
    );
  }
}
