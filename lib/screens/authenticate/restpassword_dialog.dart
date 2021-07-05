import 'package:flutter/material.dart';

class ResetPasswordDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Reset Password", style: Theme.of(context).textTheme.bodyText1),
          Icon(Icons.email, color: Theme.of(context).accentColor)
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Reset your password via the link sent to your email.',
              style: Theme.of(context).textTheme.bodyText2)
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                primary: Theme.of(context).accentColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK", style: Theme.of(context).textTheme.button))
      ],
    );
  }
}
