import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
          child: SizedBox(
        height: 100,
        width: 100,
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
          value: null,
          strokeWidth: 10,
        ),
      )),
    );
  }
}
