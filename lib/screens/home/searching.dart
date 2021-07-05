import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchingAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: SpinKitRipple(
            color: Colors.white,
            size: 1000.0,
          ),
        ),
        Center(
          child: Image.asset("assets/doodlebat.png"),
        ),
      ],
    );
  }
}
