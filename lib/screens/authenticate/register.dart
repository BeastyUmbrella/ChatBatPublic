import 'package:chatbat/services/auth.dart';
import 'package:chatbat/shared/constants.dart';
import 'package:chatbat/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String confirmPassword = '';
  String displayName = '';
  String error = '';
  bool termsAndConditionsAccepted = false;

  @override
  Widget build(BuildContext context) {
    void _privacyPoliicy() {
      showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Icon(
              Icons.privacy_tip,
              color: Theme.of(context).accentColor,
            )
          ]),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: SingleChildScrollView(child: Html(data: htmlData)),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  primary: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close')),
          ],
        ),
      );
    }

    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              iconTheme: Theme.of(context).iconTheme,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0.0,
              title: Text(
                "ChatBat",
              ),
              actions: <Widget>[
                Transform.scale(
                    scale: 0.85, child: Image.asset("assets/splashscreen.png")),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text("Register",
                                style: Theme.of(context).textTheme.headline5),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            hintText: 'Display Name',
                            hintStyle: Theme.of(context).textTheme.bodyText2,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorLight,
                                    width: 2)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight,
                                  width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Enter a Display Name' : null,
                          onChanged: (val) {
                            setState(() => displayName = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            hintText: 'Email',
                            hintStyle: Theme.of(context).textTheme.bodyText2,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorLight,
                                    width: 2)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight,
                                  width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Enter a valid Email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            hintText: 'Password',
                            hintStyle: Theme.of(context).textTheme.bodyText2,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorLight,
                                    width: 2)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight,
                                  width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          validator: (val) => val.length < 5
                              ? 'Passwords must be at least 6 characters'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            hintText: 'Confirm Password',
                            hintStyle: Theme.of(context).textTheme.bodyText2,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorLight,
                                    width: 2)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight,
                                  width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          validator: (val) => confirmPassword != password
                              ? 'Password must match'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => confirmPassword = val);
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'I accept the ',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            GestureDetector(
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                _privacyPoliicy();
                              },
                            ),
                            Theme(
                                data: ThemeData(
                                    unselectedWidgetColor:
                                        Theme.of(context).accentColor),
                                child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Theme.of(context).accentColor,
                                    value: this.termsAndConditionsAccepted,
                                    onChanged: (bool value) {
                                      setState(() {
                                        this.termsAndConditionsAccepted = value;
                                      });
                                    })),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 240,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                primary: Theme.of(context).accentColor),
                            onPressed: () async {
                              if (_formKey.currentState.validate() &&
                                  termsAndConditionsAccepted) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                        email, password, displayName);
                                if (result == null) {
                                  setState(() {
                                    error =
                                        'Please check your information and try agian';
                                    loading = false;
                                  });
                                }
                              } else if (!termsAndConditionsAccepted) {
                                setState(() {
                                  error = "Please accept the privacy policy";
                                });
                              }
                            },
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  "Register",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.button,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                IconTheme(
                                    data: Theme.of(context).iconTheme,
                                    child: Icon(Icons.person_add_alt_1))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                error,
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 106,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account? ",
                                style: Theme.of(context).textTheme.bodyText1),
                            GestureDetector(
                              onTap: () {
                                widget.toggleView();
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          );
  }
}
